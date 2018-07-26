
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        mutate(annotation = if_else(annotation %in% c("quintile 1", "quintile 5"), annotation, "quintiles 2-4")) %>%
        group_by(group, annotation, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("WT-37C", "spt6-1004-37C"),
                               labels = c("WT", "italic(\"spt6-1004\")"))) %>%
        return()
}

main = function(theme_spec,
                mnase_data,
                annotation,
                assay,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")
    max_length=1.5

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    df = import(mnase_data, sample_list=sample_list) %>%
        mutate_at(vars(-c(group, annotation, position)), funs(.*10)) %>%
        mutate(annotation = ordered(annotation,
                                    levels = c("quintile 1",
                                               "quintiles 2-4",
                                               "quintile 5")))

    supp_four_b = ggplot() +
        # geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(data = df, aes(x=position, ymin=low, ymax=high, fill=group), alpha=0.2, linetype='blank') +
        geom_line(data = df, aes(x=position, y=mid, color=group), alpha=0.7) +
        geom_text(data = tibble(annotation = ordered(c("quintile 1", "quintiles 2-4", "quintile 5")),
                                label = c(paste("top 20%",  assay),
                                          paste("middle 60%", assay),
                                          paste("bottom 20%", assay))),
                  aes(label=label), x=0.02, y=3.2/2, size=7/72*25.4, hjust=0) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "+1 dyad",
                                                          x==max_length ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=2),
                           labels = function(x){if_else(x<0, abs(x), x)},
                           name = "normalized counts") +
        ggtitle("MNase-seq dyad signal") +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        facet_grid(annotation~.) +
        theme_default

    supp_four_b %<>% add_label("B")

    ggsave(svg_out, plot=supp_four_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_four_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_four_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_four_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     mnase_data = snakemake@input[["mnase_data"]],
     annotation = snakemake@input[["annotation"]],
     assay = snakemake@params[["assay"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

