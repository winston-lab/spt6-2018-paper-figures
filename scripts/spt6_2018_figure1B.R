
main = function(theme_spec, data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(data_path) %>%
        select(c(1,2,15,16,17,18,19)) %>%
        magrittr::set_colnames(c("sample", "factor_id", "gray_min", "gray_max", "gray_mean", "gray_median", "auc")) %>%
        select(sample, factor_id, auc) %>%
        spread(key=factor_id, value=auc) %>%
        separate(col=sample, into=c("group", "replicate"), sep="-", remove=FALSE, convert=TRUE) %>%
        mutate_at(vars(DST1, SPT6), funs(.-background)) %>%
        mutate(spikenorm=SPT6/DST1,
               group = ordered(group, levels=c("WT", "spt6"), labels=c("WT", "italic(\"spt6-1004\")"))) %>%
        group_by(group) %>%
        mutate(group_mean = mean(spikenorm))

    #rescale data so that mean of WT group is 1
    wt_og_mean = df %>%
        filter(group=="WT") %>%
        distinct(group_mean) %>%
        pull(group_mean)

    df %<>% mutate(spikenorm_scaled = scales::rescale(spikenorm, from=c(0, wt_og_mean)))

    summary_df = df %>%
        summarise(group_mean_scaled = mean(spikenorm_scaled),
                  group_sd = sd(spikenorm_scaled))

    max_y = summary_df %>%
        mutate(max_y = (group_mean_scaled+group_sd)*1.05) %>%
        pull(max_y) %>% max()

    barplot = ggplot() +
        geom_col(data = summary_df, aes(x=group, y=group_mean_scaled, fill=group), alpha=0.8) +
        geom_errorbar(data = summary_df, width=0.2,
                      aes(x=group, ymin=group_mean_scaled-group_sd,
                          ymax=group_mean_scaled+group_sd), alpha=0.9) +
        geom_jitter(data = df, aes(x=group, y=spikenorm_scaled),
                    width=0.2, size=1, alpha=0.9) +
        geom_text(data = summary_df, parse=TRUE,
                  aes(x=group,
                      y=if_else(group_mean_scaled>0.2 ,
                                (group_mean_scaled-group_sd)-0.1,
                                (group_mean_scaled+group_sd+0.1)),
                      label = paste(round(group_mean_scaled,2), "%+-%", round(group_sd, 2))),
                  size=7/72*25.4) +
        scale_fill_ptol(guide=FALSE) +
        scale_x_discrete(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_y_continuous(limits = c(0, max_y),
                           breaks = c(0, 1),
                           expand=c(0,0),
                           name="relative signal (a.u.)") +
        # ggtitle("SPT6 levels by Western blot") +
        theme_default +
        theme(axis.text.x = element_text(margin=margin(t=3, unit="pt")),
              axis.title.x = element_blank(),
              panel.border = element_blank(),
              panel.grid.major.x = element_blank())

    fig_one_b = arrangeGrob(textGrob(label="BLOT GOES HERE"),
                 barplot, ncol=1) %>%
        add_label("B")

    ggsave(svg_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
