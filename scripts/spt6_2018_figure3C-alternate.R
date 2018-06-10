
main = function(theme_spec, netseq_data, annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    sample_list = c("spt6-1004-30C-1", "spt6-1004-30C-2", "spt6-1004-37C-1", "spt6-1004-37C-2", "set2D")

    df = read_tsv(netseq_data, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter(sample %in% sample_list & ! is.na(signal) & position %>% between(-0.2, 2.2)) %>%
        group_by(group, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("set2D", "spt6-1004-30C", "spt6-1004-37C"),
                               labels = c("italic(\"set2\"*Delta)",
                                          "italic(\"spt6-1004\")*\",\" ~ 30*degree*C",
                                          "italic(\"spt6-1004\")*\",\" ~ 37*degree*C")))

    fig_three_c = ggplot() +
        geom_vline(xintercept = c(0, 2),
                   size=0.5, color="grey65") +
        geom_ribbon(data = df,
                    aes(x=position, ymin=low, ymax=high),
                    alpha=0.4, size=NA, color=NA, fill="#114477") +
        geom_line(data = df,
                  aes(x=position, y=mid),
                  color="#114477", size=0.5) +
        geom_label(data = tibble(group=c("italic(\"set2\"*Delta)",
                                          "italic(\"spt6-1004\")*\",\" ~ 30*degree*C",
                                          "italic(\"spt6-1004\")*\",\" ~ 37*degree*C")),
                  aes(label=group),
                  x=0.01, y=0.05, hjust=0, size=7/72*25.4, parse=TRUE,
                  label.r = unit(0,"pt"), label.padding = unit(2, "pt"), label.size=NA) +
        scale_x_continuous(expand = c(0,0),
                           breaks = c(0, 1, 2),
                           labels = c("sense TSS", "", "CPS")) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=1),
                           limits = c(NA, max(df[["high"]])*1.15),
                           name = "normalized counts") +
        facet_grid(group~.) +
        ggtitle("antisense NET-seq signal") +
        theme_default +
        theme(panel.spacing.y = unit(3, "pt"),
              axis.title.y = element_text(margin=margin(r=2, unit="pt")),
              axis.title.x = element_blank(),
              panel.grid.major.y = element_blank(),
              panel.grid.minor.y = element_blank())

    fig_three_c %<>% add_label("C")

    ggsave(svg_out, plot=fig_three_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_three_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_three_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_three_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     netseq_data = snakemake@input[["netseq_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

