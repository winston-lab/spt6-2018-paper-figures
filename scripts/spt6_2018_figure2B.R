
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        # group_by(group, annotation, position) %>%
        select(-c(annotation, assay, index)) %>%
        mutate(group = ordered(group,
                               levels = c("spt6+", "spt6-1004-37C"),
                               labels = c("WT", "italic(\"spt6-1004\")"))) %>%
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

main = function(theme_spec, seq_data_path, qpcr_data_path,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(cowplot)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")
    gene_id = "VAM6"

    df = import(seq_data_path, sample_list=sample_list) %>%
        filter(signal !=0)

    qpcr_df = build_qpcr_df(qpcr_data_path, gene_id=gene_id, norm="pma1+")

    txn_end = max(c(qpcr_df[["transcript_start"]], qpcr_df[["transcript_end"]]))
    orf_start = min(c(qpcr_df[["orf_start"]], qpcr_df[["orf_end"]]))
    orf_end = max(c(qpcr_df[["orf_start"]], qpcr_df[["orf_end"]]))

    seq_plot = ggplot() +
        # geom_hline(yintercept = 0) +
        geom_vline(data = qpcr_df %>%
                       distinct(amplicon_start, amplicon_end) %>%
                       gather(key, coord),
                   aes(xintercept = coord), linetype="dashed", color="grey65",
                   alpha=0.4, size=0.3) +
        geom_col(data = df %>% filter(group=="WT"),
                 aes(x=position, fill=group, color=group, y=-signal), alpha=0.5, size=0.01,
                 position=position_identity()) +
        geom_col(data = df %>% filter(group!="WT"),
                 aes(x=position, fill=group, color=group, y=signal), alpha=0.5, size=0.01,
                 position=position_identity()) +
        scale_x_continuous(expand=c(0,0),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==3 ~ paste0(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        # scale_y_continuous(limits = c(-1, NA),
        scale_y_continuous(limits = c(NA, NA),
                           labels = function(x){abs(x)},
                           name = "normalized counts",
                           breaks = scales::pretty_breaks(n=2)) +
        scale_fill_manual(labels = c(bquote(italic("spt6-1004")), "WT"),
                          values=rev(ptol_pal()(2))) +
        scale_color_manual(labels = c(bquote(italic("spt6-1004")), "WT"),
                          values=rev(ptol_pal()(2))) +
        ggtitle("TFIIB ChIP-nexus protection") +
        theme_default +
        theme(legend.position = c(0.8, 0.75),
              legend.justification = c(0.5, 0.5),
              legend.key.size = unit(10, "pt"),
              legend.background = element_rect(fill="white", size=0),
              axis.title.x = element_blank())

     diagram = ggplot() +
         geom_vline(data = qpcr_df %>%
                        distinct(amplicon_start, amplicon_end) %>%
                        gather(key, coord),
                    aes(xintercept = coord), linetype="dashed", color="grey65", size=0.3) +
         annotate(geom="segment", color="black", size=2,
                  x=0, xend=txn_end, y=0, yend=0) +
         annotate(geom="rect", color="black", fill="grey95", size=0.3,
                  xmin=orf_start, xmax=orf_end, ymin=-1, ymax=1) +
         annotate(geom="text", label=gene_id, x=(orf_start+orf_end)/2,
                  y = 0, size=9/72*25.4) +
         scale_x_continuous(limits = c(min(df[["position"]]), max(df[["position"]])),
                            expand=c(0,0)) +
         scale_y_continuous(limits = c(-1.5, 1.5), expand=c(0,0)) +
         theme_void()

    qpcr_plot = ggplot(data = qpcr_df,
                  aes(x=(amplicon_start+amplicon_end)/2, y=value*100,
                      group=interaction(amplicon_start, condition))) +
        geom_vline(aes(xintercept = amplicon_start), linetype="dashed", alpha=0.25, size=0.3) +
        geom_vline(aes(xintercept = amplicon_end), linetype="dashed", alpha=0.25, size=0.3) +
        geom_boxplot(position=position_dodge(.45), width=.4, size=0.3) +
        geom_point(aes(color=condition),
                   position=position_jitterdodge(jitter.width=.4, dodge.width = .45),
                   size=1.3, alpha=0.9) +
        scale_color_ptol(labels=c("WT", bquote(italic("spt6-1004"))), guide=guide_legend(reverse = TRUE)) +
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
              legend.key.size = unit(10, "pt"),
              legend.background = element_rect(fill="white", size=0),
              axis.title.x = element_blank())

    fig_two_b = plot_grid(seq_plot, diagram, qpcr_plot, ncol=1, align="v", axis="lr", rel_heights = c(1,0.15,1)) %>%
        add_label("B")

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    ggplot2::ggsave(svg_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     seq_data_path = snakemake@input[["seq_data"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
