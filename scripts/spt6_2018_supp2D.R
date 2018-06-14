
main = function(theme_spec, data_path, blot_image,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(png)

    df = read_csv(data_path) %>%
        select(c(1,2,15,16,17,18,19)) %>%
        magrittr::set_colnames(c("sample", "factor_id", "gray_min", "gray_max", "gray_mean", "gray_median", "auc")) %>%
        select(sample, factor_id, auc) %>%
        spread(key=factor_id, value=auc) %>%
        magrittr::set_colnames(c("sample", "background", "spikein", "tfiib")) %>%
        separate(col=sample, into=c("group", "replicate"), sep="-", remove=FALSE, convert=TRUE) %>%
        mutate_at(vars(spikein, tfiib), funs(.-background)) %>%
        mutate(spikenorm=tfiib/spikein,
               group = ordered(group, levels=c("wt", "spt"), labels=c("WT", "italic(\"spt6-1004\")"))) %>%
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
        mutate(max_y = (group_mean_scaled+group_sd+0.05)*1.05) %>%
        pull(max_y) %>% max()

    barplot = ggplot() +
        geom_col(data = summary_df, aes(x=group, y=group_mean_scaled, fill=group), alpha=0.8) +
        geom_errorbar(data = summary_df, width=0.2,
                      aes(x=group, ymin=group_mean_scaled-group_sd,
                          ymax=group_mean_scaled+group_sd), alpha=0.9) +
        geom_jitter(data = df, aes(x=group, y=spikenorm_scaled),
                    width=0.2, size=1, alpha=0.9) +
        geom_text(data = summary_df, parse=TRUE,
                  aes(x=group, y=(group_mean_scaled+group_sd)+0.05,
                      label = paste(round(group_mean_scaled,2), "%+-%", round(group_sd, 2))),
                  size=7/72*25.4) +
        scale_fill_ptol(guide=FALSE) +
        scale_x_discrete(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_y_continuous(limits = c(0, max_y),
                           breaks = c(0,1),
                           expand=c(0,0),
                           name="relative signal") +
        # ggtitle("TFIIB levels by Western blot",
        #         subtitle = "normalized to Dst1 spike-in") +
        theme_default +
        theme(axis.text.x = element_text(margin=margin(t=3, unit="pt")),
              axis.title.x = element_blank(),
              panel.border = element_blank(),
              panel.grid.major.x = element_blank())

    blot = rasterGrob(readPNG(blot_image),
                      width=0.5, height=0.7,
                      x = 0.34, y = 0.5,
                      hjust=0)
    outline = rectGrob(width=0.5, height=0.7,
                       x=0.34, y=0.5, hjust=0,
                       gp = gpar(lwd=1, fill=NA))
    tfiib_label = textGrob(label = "TFIIB-TAP",
                           x=0.32, y=0.535, hjust=1,
                           gp = gpar(fontsize=7))
    dst1_label = textGrob(label = "Dst1-Myc",
                           x=0.32, y=0.465, hjust=1,
                           gp = gpar(fontsize=7))
    wt_lane_label = textGrob(label = "WT",
                             x = 0.47, y=0.87, vjust=0,
                             gp =gpar(fontsize=7))
    spt6_lane_label = textGrob(label = expression(italic("spt6-1004")),
                             x = 0.70, y=0.862, vjust=0,
                             gp =gpar(fontsize=7))
    temp_line = linesGrob(x=c(0.35, 0.82), y=c(0.92, 0.92))
    temp_label = textGrob(label = expression(37*degree*C),
                          x=0.59, y=0.95,
                          gp = gpar(fontsize=7))

    western = gTree(children = gList(blot, outline,
                                     tfiib_label, dst1_label,
                                     wt_lane_label, spt6_lane_label,
                                     temp_line, temp_label))

    supp_two_d = arrangeGrob(western, barplot, nrow=1, widths=c(1,1)) %>%
        add_label("D")

    ggsave(svg_out, plot=supp_two_d, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_two_d, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_two_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_two_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     blot_image = snakemake@input[["image"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

