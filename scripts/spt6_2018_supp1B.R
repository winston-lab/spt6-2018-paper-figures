library(ggforce)


import = function(path){
    # We want to look at signal vs. noise rather than capturing
    # variation in expression, so for each gene we rescale 0 to 1
    read_tsv(path,
             col_names = c("group", "sample", "index", "position", "signal")) %>%
        filter((group %in% c("doris", "malabat")) & ! is.na(signal)) %>%
        group_by(group, index) %>%
        mutate(signal = scales::rescale(signal, to=c(0,1))) %>%
        group_by(group, position) %>%
        summarise(mid = median(signal, na.rm=TRUE),
                  low = quantile(signal, 0.1, na.rm=TRUE),
                  high = quantile(signal, 0.9, na.rm=TRUE)) %>%
        ungroup() %>%
        return()
}

main = function(theme_spec,
                data_path,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    #NOTE: group filtering is hardcoded in import function
    df = import(data_path)

    supp_one_b = ggplot(data = df, aes(x=position, y=mid, ymin=low, ymax=high, color=group, fill=group)) +
        geom_vline(xintercept = c(0,2), size=0.2, color="grey65") +
        geom_ribbon(alpha=0.2, size=0, position=position_dodge(width=0.1)) +
        geom_line(position=position_dodge(width=0.08), size=0.3, alpha=0.8) +
        facet_zoom(xy=position > 0.5 & position < 1.5,
                   horizontal=FALSE, zoom.size=1) +
        scale_color_tableau(labels = c("this work", bquote(Malabat ~ italic("et al.") ~ 2015)),
                            guide=guide_legend(keyheight=unit(9, "pt"),
                                               keywidth=unit(9, "pt"))) +
        scale_fill_tableau(labels = c("this work", bquote(Malabat ~ italic("et al.") ~ 2015)),
                           guide=guide_legend(keyheight=unit(9, "pt"),
                                              keywidth=unit(9, "pt"))) +
        scale_x_continuous(breaks = c(0,1,2),
                           labels = c("TSS", "", "CPS"),
                           expand = c(0,0)) +
        scale_y_continuous(name = "relative signal",
                           breaks = scales::pretty_breaks(n=1)) +
        ggtitle("relative sense TSS-seq signal") +
        theme_default +
        theme(strip.background = element_rect(fill="grey90", size=0),
              axis.title.x = element_blank(),
              legend.position = c(0.5, 0.9),
              legend.justification = c(0.5, 0.5),
              legend.text = element_text(size=7),
              panel.spacing.y = unit(0.5, "pt"),
              axis.title.y = element_text(margin = margin(r=8, unit="pt")))

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    supp_one_b %<>% add_label("b")

    ggsave(svg_out, plot=supp_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["tss_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])


