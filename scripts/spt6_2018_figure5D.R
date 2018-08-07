
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
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(broom)

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
        geom_area(na.rm=TRUE, alpha=0.8, size=0) +
        geom_vline(xintercept = 0, color="grey65", size=1.5) +
        scale_x_continuous(limits = c(-200, 0),
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=3),
                           labels = function(x) case_when(x==-200 ~ "-200 nt",
                                                          x==0 ~ "TSS",
                                                          TRUE ~ as.character(x))) +
        scale_y_continuous(limits = c(0, 0.01),
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=1),
                           name = "scaled density") +
        scale_color_tableau() +
        scale_fill_tableau() +
        ggtitle("TATA consensus") +
        theme_default +
        theme(axis.title.x = element_blank(),
              axis.line.y = element_line(size=0.25, color="grey65"),
              axis.text.y = element_text(size=5),
              axis.title.y = element_text(margin = margin(r=-5, unit="pt")),
              panel.border = element_blank(),
              panel.grid = element_blank(),
              legend.justification = c(0.5, 0.5),
              legend.position = c(0.70, 0.7),
              legend.key.width= unit(8, "pt"),
              plot.margin = margin(2, 11, 1, 6, "pt"))

    fig_five_d = tata %>%
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
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

