
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        group_by(group, annotation, position) %>%
        # summarise(mid = median(signal),
        #           low = quantile(signal, 0.25),
        #           high = quantile(signal, 0.75)) %>%
        summarise(mid = winsor.mean(signal, trim=0.01),
                  sd = winsor.sd(signal, trim=0.01)) %>%
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
                                    labels = c("\"312 TSSs upregulated in\" ~ italic(\"spt6-1004\")",
                                               "\"1284 TSSs not significantly changed\"",
                                               "\"4206 TSSs downregulated\""))) %>%
        return()
}

main = function(theme_spec,
                mnase_data,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(psych)
    sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    max_length=0.2

    df = import(mnase_data, sample_list=sample_list) %>%
        mutate_at(vars(-c(group, annotation, position)), funs(.*10))

    fig_six_b = ggplot() +
        geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(data = df,
                    aes(x=position, ymin=low, ymax=high, fill=group),
                    alpha=0.2, linetype="blank") +
        geom_line(data = df,
                  aes(x=position, y=mid, color=group),
                  alpha=0.7) +
        geom_label(data = df %>% distinct(annotation),
                  aes(label = annotation),
                  fill="white", label.size=NA, label.r=unit(0,"pt"), label.padding=unit(0,"pt"),
                  x=-0.29, y=4.5, size=7/72*25.4, parse=TRUE, hjust=0) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          near(x,max_length) ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(limits = c(0, max(df[["high"]])*1.05),
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=3),
                           labels = function(x){if_else(x<0, abs(x), x)},
                           name = "normalized counts") +
        facet_grid(annotation~., labeller=label_parsed) +
        ggtitle("MNase-seq dyad signal at genic TSSs") +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004"))),
                         guide=guide_legend(keyheight=unit(10, "pt"))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        theme_default +
        theme(panel.grid = element_blank(),
              panel.spacing.y = unit(3, "pt"))

    fig_six_b %<>% add_label("B")

    ggsave(svg_out, plot=fig_six_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_b, file=grob_out)
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

