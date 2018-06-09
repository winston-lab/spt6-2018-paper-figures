
main = function(theme_spec, tfiib_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(ggforce)

    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    df = read_tsv(tfiib_data,
                  col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter(sample %in% sample_list) %>%
        group_by(group, position) %>%
        summarise(signal = mean(signal)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("spt6+", "spt6-1004-37C"),
                               labels = c("WT", "spt6-1004")))

    fig_two_b = ggplot(data = df, aes(x=position, y=signal, fill=group)) +
        geom_area(alpha=0.5, position=position_identity()) +
        scale_x_continuous(expand = c(0,0),
                           breaks = scales::pretty_breaks(3),
                           labels = function(x) case_when(x %>% near(10) ~ "+10kb",
                                                          x %>% near(2) ~ "+2kb",
                                                          x > 0 ~ paste0("+", x),
                                                          TRUE ~ as.character(x))) +
        scale_y_continuous(limits = c(NA, 1), oob=scales::squish,
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=1),
                           name = "normalized counts") +
        facet_zoom(x=position > -0.3 & position < 2.111+0.3,
                   horizontal=FALSE, zoom.size=1) +
        annotate(geom="segment", x=0, xend=2.111, y=0.7, yend=0.7) +
        annotate(geom="rect", xmin=0.054, xmax=1.983, ymin=0.60, ymax=0.80,
                 fill="grey75") +
        annotate(geom="text", x=2.111/2, y=0.7, label="italic(\"SSA4\")", size=7/72*25.4,
                 parse=TRUE) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        ggtitle("TFIIB ChIP-nexus protection") +
        theme_default +
        theme(strip.background = element_rect(fill="grey80", size=0, color=NA),
              axis.title.y = element_text(margin=margin(r=6, unit="pt")),
              axis.title.x = element_blank(),
              panel.border = element_blank(),
              panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank(),
              panel.spacing.y = unit(1, "pt"),
              plot.margin = margin(0, 0, -11, 11/2 ))

    fig_two_b %<>% add_label("B")

    ggplot2::ggsave(svg_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two_b, file=grob_out)
}


main(theme_spec = snakemake@input[["theme"]],
     tfiib_data = snakemake@input[["tfiib_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
