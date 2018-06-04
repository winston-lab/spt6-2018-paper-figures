
import = function(path, annotation_id){
    read_tsv(path, col_types = 'ciicdcciicdccc') %>%
        mutate(start = case_when(region_strand=="+" & motif_chrom != "." ~ region_start-motif_start,
                                 region_strand=="-" & motif_chrom != "." ~ motif_start-region_end,
                                 motif_chrom=="." ~ as.integer(NaN)),
               end = case_when(region_strand=="+" & motif_chrom != "." ~ region_start-motif_end,
                               region_strand=="-" & motif_chrom != "." ~ motif_end-region_end,
                               motif_chrom=="." ~ as.integer(NaN)),
               annotation = annotation_id) %>%
        arrange(region_score) %>%
        return()
}

main = function(theme_spec,
                tata_genic_path, tata_intra_path, tata_random_path,
                all_motif_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(broom)
    library(stringr)
    library(ggrepel)

    df = tata_genic_path %>%
        import(annotation_id = "genic") %>%
        bind_rows(tata_intra_path %>% import(annotation_id = "intragenic")) %>%
        bind_rows(tata_random_path %>% import(annotation_id = "random")) %>%
        group_by(annotation) %>%
        mutate(n_regions = n_distinct(chrom, region_start, region_end, region_strand)) %>%
        filter(motif_start >= 0) %>%
        mutate(n_motifs = n()) %>%
        ungroup() %>%
        transmute(annotation = fct_inorder(annotation, ordered=TRUE),
                  n_regions = n_regions,
                  n_motifs = n_motifs,
                  position = (end+start)/2) %>%
        group_by(annotation, n_regions, n_motifs) %>%
        do(density(x=.$position,
                   from = -600,
                   to = 0,
                   cut = 0,
                   bw = 2,
                   kernel="gaussian") %>%
               tidy())

    tata = ggplot(data = df,
           aes(x=x, y=y*n_motifs/n_regions, fill=annotation, color=annotation)) +
        geom_area(na.rm=TRUE, alpha=0.9) +
        geom_vline(xintercept = 0, color="grey65", size=2) +
        scale_x_continuous(limits = c(-200, 0),
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=3),
                           labels = function(x) case_when(x==-200 ~ "-200nt",
                                                          x==0 ~ "TSS",
                                                          TRUE ~ as.character(x))) +
        scale_y_continuous(limits = c(0, 0.01),
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=1),
                           name = "scaled density") +
        scale_color_tableau() +
        scale_fill_tableau() +
        ggtitle("TATAWAWR") +
        theme_default +
        theme(axis.title.x = element_blank(),
              axis.line.y = element_line(size=0.25, color="grey65"),
              axis.text.y = element_text(size=5),
              axis.title.y = element_text(margin = margin(r=0, unit="pt")),
              panel.border = element_blank(),
              panel.grid = element_blank(),
              legend.justification = c(0.5, 0.5),
              legend.position = c(0.70, 0.7),
              legend.key.width= unit(8, "pt"))

    all_df = read_tsv(all_motif_path) %>%
        mutate(label = if_else(is.na(motif_alt_id), motif_id, motif_alt_id)) %>%
        separate(label, into=c("label", "ext"), sep = "\\.", fill="right") %>%
        select(-ext) %>%
        mutate(label = label %>%
                   str_remove("p$") %>%
                   str_to_title(),
               label = if_else(str_detect(label, "^Y[a-p][rl]\\d+[wc]$"),
                               str_to_upper(label),
                               label))

    volcano_plot = ggplot() +
        geom_vline(xintercept = 0, color="grey65", size=0.5) +
        geom_point(data = all_df %>% filter(fdr>=0.01),
                   aes(x=log2_odds_ratio, y=-log10(fdr)),
                   size=0.4, alpha=0.4, color="grey40") +
        geom_hline(yintercept = -log10(0.01),
                   linetype="dashed") +
        geom_label_repel(data = all_df %>% filter(fdr<0.01),
                  aes(x=log2_odds_ratio, y=-log10(fdr), label=label,
                      fill=if_else(log2_odds_ratio<0, "depleted", "enriched")),
                  size=5/72*25.4,
                  box.padding = unit(0, "pt"), label.r = unit(0.5, "pt"),
                  label.size=NA, label.padding = unit(0.8, "pt"),
                  ylim = c(-log10(0.02), NA), force=0.5,
                  segment.size = 0.2) +
        annotate(geom="label", x=1, y=9.7, label="enriched", size=7/72*25.4,
                 fill="#fbb4ae", label.size=NA) +
        annotate(geom="label", x=-1, y=9.7, label="depleted", size=7/72*25.4,
                 fill="#b3cde3", label.size=NA) +
        scale_y_continuous(expand = c(0,0),
                           breaks = scales::pretty_breaks(n=3),
                           name = expression(-log[10]("FDR"))) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=5),
                           name = expression(log[2]("odds ratio vs. random"))) +
        scale_fill_brewer(palette = "Pastel1", direction=-1, guide=FALSE) +
        ggtitle(bquote("motifs at" ~ italic("spt6-1004") ~ "iTSSs")) +
        theme_default +
        theme(panel.grid = element_blank(),
              panel.border = element_blank(),
              axis.line = element_line(color="grey65", size=0.2),
              axis.title.y = element_text(margin=margin(r=0, unit="pt")))

    fig_five_d = arrangeGrob(tata, volcano_plot, heights = c(0.5, 1)) %>%
        add_label("D")

    ggsave(svg_out, plot=fig_five_d, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_five_d, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_five_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_five_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     tata_genic_path = snakemake@input[["tata_genic_path"]],
     tata_intra_path = snakemake@input[["tata_intra_path"]],
     tata_random_path = snakemake@input[["tata_random_path"]],
     all_motif_path = snakemake@input[["all_motif_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
