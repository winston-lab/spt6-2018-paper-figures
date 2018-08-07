
main = function(theme_spec, sense_tfiib_path, antisense_tfiib_path,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    sample_list = c("WT-37C-1", "WT-37C-2")

    df = read_tsv(sense_tfiib_path,
                  col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        mutate(strand="sense") %>%
        bind_rows(read_tsv(antisense_tfiib_path,
                           col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
                      filter((sample %in% sample_list) & ! is.na(signal)) %>%
                      mutate(strand="antisense")) %>%
        group_by(group, sample, annotation, index) %>%
        mutate(signal = scales::rescale(signal)) %>%
        group_by(group, annotation, position, strand) %>%
        summarise(mid = mean(signal),
                  sd = sd(signal))

    spread_df = df %>% filter(strand=="sense") %>%
        left_join(df %>% filter(strand=="antisense"),
                  by=c("group", "annotation", "position"),
                  suffix = c("_sense", "_anti")) %>%
        ungroup()

    supp_two_c = ggplot(data = spread_df, aes(x=position)) +
        annotate(geom="rect", xmin=0, xmax=0.008,
                 ymin=-max(spread_df[["mid_anti"]])*1.05,
                 ymax=max(spread_df[["mid_sense"]]*1.05),
                 alpha=0.3) +
        geom_col(aes(y=mid_sense), fill="#114477", color="#114477", size=0.1) +
        geom_col(aes(y=-mid_anti), fill="#4477AA", color="#4477AA", size=0.1) +
        scale_x_continuous(expand = c(0,0),
                           labels = function(x) case_when(x==0 ~ "TATA",
                                                         x==.120 ~ "120 nt",
                                                         TRUE ~ as.character(x*1e3)),
                           name = NULL) +
        scale_y_continuous(expand = c(0,0),
                           labels = function(x) abs(x),
                           name="relative signal") +
        ggtitle("TFIIB ChIP-nexus signal") +
        theme_default

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    supp_two_c %<>% add_label("C")

    ggsave(svg_out, plot=supp_two_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_two_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_two_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_two_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     sense_tfiib_path = snakemake@input[["sense_tfiib_data"]],
     antisense_tfiib_path = snakemake@input[["antisense_tfiib_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

