
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        select(-c(annotation, assay, index)) %>%
        mutate(group = ordered(group,
                               levels = c("spt6+", "spt6-1004-37C"),
                               labels = c("WT", "spt6-1004"))) %>%
        return()
}

build_qpcr_df = function(path, gene_id, norm="input"){
    df = read_tsv(path) %>%
        mutate(condition=fct_inorder(condition))
    subdf = df %>%
        filter(gene==gene_id)
    if (norm != "input"){
        subdf = df %>% filter(gene==norm) %>%
            select(condition, replicate, spikein=value) %>%
            left_join(subdf, ., by=c("condition", "replicate")) %>%
            mutate(value=value/spikein)
    }

    strand = subdf %>% distinct(strand) %>% pull(strand)
    if (strand=="+"){
        subdf %<>%
            mutate_at(vars(amplicon_start, amplicon_end, transcript_end, orf_start, orf_end, transcript_start),
                      funs((.-transcript_start))/1e3)
    } else if (strand=="-"){
        subdf %<>%
            mutate_at(vars(amplicon_start, amplicon_end, transcript_start, orf_start, orf_end, transcript_end),
                      funs((transcript_end-.)/1e3))
    }
    return(subdf)
}

build_combined_figure = function(df, qpcr_data_path, gene_id){
    qpcr_df = build_qpcr_df(qpcr_data_path, gene_id=gene_id, norm="pma1+")

    txn_end = max(c(qpcr_df[["transcript_start"]], qpcr_df[["transcript_end"]]))
    orf_start = min(c(qpcr_df[["orf_start"]], qpcr_df[["orf_end"]]))
    orf_end = max(c(qpcr_df[["orf_start"]], qpcr_df[["orf_end"]]))

    seq_plot = ggplot() +
        geom_vline(data = qpcr_df %>%
                       distinct(amplicon_start, amplicon_end) %>%
                       gather(key, coord),
                   aes(xintercept = coord), linetype="dashed",
                   alpha=0.3, size=0.3) +
        geom_area(data = df,
                  aes(x=position, y=signal, fill=group),
                  position=position_identity(),
                  alpha=0.75) +
        scale_x_continuous(expand=c(0,0),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==3 ~ paste0(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        # scale_y_continuous(limits = c(-1, NA),
        scale_y_continuous(limits = c(NA, NA),
                           labels = function(x){abs(x)},
                           name = "normalized counts",
                           breaks = scales::pretty_breaks(n=2)) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        ggtitle("TFIIB ChIP-nexus protection") +
        theme_default +
        theme(legend.position = c(0.8, 0.75),
              legend.justification = c(0.5, 0.5),
              axis.title.x = element_blank(),
              panel.border = element_blank())

    diagram = ggplot() +
        geom_vline(data = qpcr_df %>%
                       distinct(amplicon_start, amplicon_end) %>%
                       gather(key, coord),
                   aes(xintercept = coord), linetype="dashed", alpha=0.3, size=0.3) +
        annotate(geom="segment", color="black",
                 x=0, xend=txn_end, y=0, yend=0) +
        annotate(geom="rect", fill="grey80",
                 xmin=orf_start, xmax=orf_end, ymin=-1, ymax=1) +
        annotate(geom="text", label=paste0("italic(\"", gene_id, "\")"), x=(orf_start+orf_end)/2,
                 y=0, size=7/72*25.4, parse=TRUE) +
        scale_x_continuous(limits = c(min(df[["position"]]), max(df[["position"]])),
                           expand=c(0,0)) +
        scale_y_continuous(limits = c(-1.5, 1.5), expand=c(0,0)) +
        theme_void() +
        theme(plot.margin = margin(0,0,0,0,"pt"))

    qpcr_summary = qpcr_df %>%
        group_by(amplicon_start, amplicon_end, condition) %>%
        summarise(mean = mean(value*100),
                  sd = sd(value*100))

    qpcr_plot = ggplot() +
        geom_vline(data = qpcr_summary,
                   aes(xintercept = amplicon_start), linetype="dashed", alpha=0.3, size=0.3) +
        geom_vline(data = qpcr_summary,
                   aes(xintercept = amplicon_end), linetype="dashed", alpha=0.3, size=0.3) +
        geom_col(data = qpcr_summary,
                 aes(x=(amplicon_start+amplicon_end)/2, y=mean, group=condition),
                 position=position_dodge(0.45), width=0.4, alpha=0.9, size=0.2, fill="white", color="black") +
        geom_errorbar(data = qpcr_summary,
                      aes(x=(amplicon_start+amplicon_end)/2, ymin=mean-sd, ymax=mean+sd,
                          group = interaction(amplicon_start, condition)),
                      position = position_dodge(width=0.45),
                      width=0.2, alpha=0.9) +
        # geom_boxplot(position=position_dodge(.45), width=.4, size=0.3) +
        geom_point(data = qpcr_df,
                   aes(x=(amplicon_start+amplicon_end)/2, y=value*100, color=condition),
                   position=position_jitterdodge(jitter.width=.4, dodge.width = .45),
                   # position = position_dodge(width=0.45),
                   size=1.3, alpha=0.9) +
        # scale_fill_ptol(labels=c("WT", bquote(italic("spt6-1004"))), guide=guide_legend(reverse = TRUE)) +
        scale_color_ptol(labels=c("WT", bquote(italic("spt6-1004")))) +
        scale_x_continuous(limits = c(min(df[["position"]]), max(df[["position"]])),
                           expand = c(0,0),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==3 ~ paste0(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        scale_y_continuous(limits = c(0, NA),
                           breaks = scales::pretty_breaks(n=2),
                           name = "enrichment (AU)") +
        ggtitle("TFIIB ChIP-qPCR") +
        theme_default +
        theme(legend.position = c(0.8, 0.75),
              legend.justification = c(0.5, 0.5),
              axis.title.x = element_blank(),
              panel.border = element_blank())

    plot_grid(seq_plot, diagram, qpcr_plot, ncol=1, align="v", axis="lr", rel_heights = c(1,0.15,1)) %>%
        return()
}

main = function(theme_spec, pma_seq_data, hsp_seq_data, qpcr_data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(cowplot)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    pma_df = import(pma_seq_data, sample_list=sample_list)
    hsp_df = import(hsp_seq_data, sample_list=sample_list)

    pma_figure = build_combined_figure(pma_df, qpcr_data_path=qpcr_data_path, gene_id = "PMA1")
    hsp_figure = build_combined_figure(hsp_df, qpcr_data_path=qpcr_data_path, gene_id = "HSP82")
    fig_six_a = arrangeGrob(pma_figure, hsp_figure, nrow=1) %>%
        add_label("A")

    ggplot2::ggsave(svg_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     pma_seq_data = snakemake@input[["pma_seq_data"]],
     hsp_seq_data = snakemake@input[["hsp_seq_data"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
