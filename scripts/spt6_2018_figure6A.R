library(psych)

import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        group_by(group, annotation, position) %>%
        # summarise(mid = median(signal),
        #           low = quantile(signal, 0.25),
        #           high = quantile(signal, 0.75)) %>%
        summarise(mid = winsor.mean(signal, trim=0.01),
                  sd = winsor.sd(signal, trim=0.01),
                  n = n_distinct(index)) %>%
        mutate(high = mid+sd,
               low = pmax(mid-sd, 0)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("spt6+", "spt6-1004-37C"),
                               labels = c("WT", "italic(\"spt6-1004\")")),
               annotation = ordered(annotation,
                                    levels = c("spt6-1004 upregulated genic TSSs",
                                               "unchanged genic TSSs",
                                               "spt6-1004 downregulated genic TSSs"),
                                    labels = c("\"TSS upregulated in\" ~ italic(\"spt6-1004\")",
                                               "\"TSS not significantly changed\"",
                                               "\"TSS downregulated in\" ~ italic(\"spt6-1004\")"))) %>%
        return()
}

main = function(theme_spec,
                mnase_data,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    max_length=0.2

    df = import(mnase_data, sample_list=sample_list) %>%
        mutate_at(vars(-c(group, annotation, position)), funs(.*10))

    fig_six_a = ggplot() +
        geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(data = df,
                    aes(x=position, ymin=low, ymax=high, fill=group),
                    size=0, alpha=0.2) +
        geom_line(data = df,
                  aes(x=position, y=mid, color=group),
                  alpha=0.7) +
        geom_label(data = df %>% distinct(annotation),
                  aes(label = annotation),
                  fill="white", label.size=0, label.r=unit(0,"pt"), label.padding=unit(0,"pt"),
                  x=-0.29, y=4.5, size=7/72*25.4, parse=TRUE, hjust=0) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          near(x,max_length) ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){if_else(x<0, abs(x), x)},
                           name = "normalized counts") +
        facet_grid(annotation~., labeller=label_parsed) +
        ggtitle("MNase-seq dyad signal at genic TSSs") +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004"))),
                         guide=guide_legend(keyheight=unit(10, "pt"))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        theme_default

    fig_six_a %<>% add_label("a")

    ggsave(png_out, plot=fig_six_a, width=8, height=10, units="cm", dpi=326)


    ggsave(svg_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_a, file=grob_out)
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

