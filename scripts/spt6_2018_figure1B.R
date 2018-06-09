
main = function(theme_spec, data_path, blot_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(png)

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
        mutate(max_y = (group_mean_scaled+group_sd+0.12)*1.05) %>%
        pull(max_y) %>% max()

    barplot = ggplot() +
        geom_col(data = summary_df, aes(x=group, y=group_mean_scaled, fill=group), alpha=0.8) +
        geom_errorbar(data = summary_df, width=0.2,
                      aes(x=group, ymin=group_mean_scaled-group_sd,
                          ymax=group_mean_scaled+group_sd), alpha=0.9) +
        geom_jitter(data = df, aes(x=group, y=spikenorm_scaled),
                    width=0.35, size=0.7, alpha=0.9) +
        geom_text(data = summary_df, parse=TRUE,
                  aes(x=group,
                      y=group_mean_scaled+group_sd+0.12,
                      # y=if_else(group_mean_scaled>0.2 ,
                      #           (group_mean_scaled-group_sd)-0.1,
                      #           (group_mean_scaled+group_sd+0.1)),
                      label = paste(round(group_mean_scaled,2), "%+-%", round(group_sd, 2))),
                  size=5/72*25.4) +
        scale_fill_ptol(guide=FALSE) +
        scale_x_discrete(labels = c("WT", bquote(italic("spt6-1004"))),
                         expand = c(0,0)) +
        scale_y_continuous(limits = c(0, max_y),
                           breaks = c(0, 1),
                           expand=c(0,0),
                           name="relative signal") +
        # ggtitle("SPT6 levels by Western blot") +
        theme_default +
        theme(axis.text.x = element_text(margin=margin(t=3, unit="pt")),
              axis.title.x = element_blank(),
              panel.border = element_blank(),
              panel.grid.major.x = element_blank())

    blot = rasterGrob(readPNG(blot_path),
                      width=0.44, x=unit(0.445, "npc"),
                      height=0.77, y=unit(0, "npc"),
                      hjust=0, vjust=0)
    outline = rectGrob(width=0.44, x=unit(0.445, "npc"),
                       height=0.77, y=unit(0, "npc"),
                       hjust=0, vjust=0,
                       gp=gpar(lwd=1,fill=NA))
    temp_line = segmentsGrob(x0=0.45, x1=0.88, y0=0.89, y1=0.89)
    temp_label = textGrob(label = expression(37*degree*C),
                          x = .665, y=0.98,
                          vjust=1,
                          gp = gpar(fontsize=7))
    wt_lane_label = textGrob(label = "WT", x=0.53, y=0.87, vjust=1,
                             gp = gpar(fontsize=7))
    spt6_lane_label = textGrob(label = "spt6-1004", x=1, y=0.87, hjust=1,vjust=1,
                               gp = gpar(fontsize=7,fontface="italic"))
    spt6_label = textGrob(label = "Spt6-FLAG",
                          x = 0.425, y=0.55, gp = gpar(fontsize = 7),
                          hjust=1)
    dst1_label = textGrob(label = "Dst1-Myc",
                          x = 0.425, y=0.24, gp = gpar(fontsize = 7),
                          hjust=1)
    western = gTree(children = gList(blot, outline,
                                  spt6_label, dst1_label,
                                  wt_lane_label, spt6_lane_label,
                                  temp_line, temp_label))

    fig_one_b = arrangeGrob(western, barplot, ncol=1) %>%
        add_label("B")

    ggsave(svg_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     blot_path = snakemake@input[["blot_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
