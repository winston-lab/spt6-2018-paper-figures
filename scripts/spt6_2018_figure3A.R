
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

main = function(theme_spec, sense_netseq_data, antisense_netseq_data,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")
    max_length=3

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    df = import(sense_netseq_data, sample_list=sample_list) %>%
        inner_join(import(antisense_netseq_data, sample_list=sample_list),
                   by=c("group", "annotation", "position"), suffix=c("_sense", "_anti"))

    fig_three_a = ggplot(data = df, aes(x=position, color=group, fill=group)) +
        geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(aes(ymin=low_sense, ymax=high_sense), alpha=0.17, linetype='blank') +
        geom_line(aes(y=mid_sense), alpha=0.75) +
        geom_ribbon(aes(ymin=-low_anti, ymax=-high_anti),
                    alpha=0.17, show.legend = FALSE, linetype='blank') +
        geom_line(aes(y=-mid_anti), alpha=0.75, show.legend = FALSE) +
        geom_hline(yintercept = 0, size=0.5, color="black") +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          x==max_length ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){if_else(x<0, abs(x), x)},
                           name = "normalized counts") +
        ggtitle("NET-seq signal") +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        theme_default +
        theme(legend.key.height = unit(10, "pt"),
              panel.grid = element_blank(),
              legend.position = c(0.8, 0.99),
              legend.background = element_rect(color=NA, fill="white", size=0),
              plot.margin = margin(11/2, 0, -10, 0, unit="pt"))

    fig_three_a %<>% add_label("A")

    ggsave(svg_out, plot=fig_three_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_three_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_three_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_three_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     sense_netseq_data = snakemake@input[["sense_netseq_data"]],
     antisense_netseq_data = snakemake@input[["antisense_netseq_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

