
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
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
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")
    max_length=1.5

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    df = import(mnase_data, sample_list=sample_list) %>%
        mutate_at(vars(-c(group, annotation, position)), funs(.*10))

    fig_two_b = ggplot(data = df,
                       aes(x=position, color=group, fill=group)) +
        geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(aes(ymin=low, ymax=high), size=0, alpha=0.2) +
        geom_line(aes(y=mid), alpha=0.7) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "+1 dyad",
                                                          x==max_length ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){if_else(x<0, abs(x), x)},
                           name = "normalized counts") +
        ggtitle("MNase-seq dyad signal") +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        theme_default

    fig_two_b %<>% add_label("b")

    ggsave(svg_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_two_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     mnase_data = snakemake@input[["mnase_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

