
main = function(theme_spec, data_path, blot_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(png)

    df = read_tsv(data_path) %>%
        select(1,2,3,4,5,18,19,20,21,22) %>% 
        magrittr::set_colnames(c("strain", "temperature", "antigen", "background", "replicate",
                                 "gray_min", "grey_max", "gray_mean", "gray_median", "auc")) %>% 
        select(strain, temperature, antigen, background, replicate, auc) %>% 
        spread(background, auc) %>% 
        mutate(signal = pmax(`FALSE`-`TRUE`, 0)) %>% 
        select(-c(`FALSE`, `TRUE`)) %>% 
        spread(antigen, signal) %>% 
        mutate(spikenorm = Spt6/spikein) %>% 
        group_by(strain, temperature) %>% 
        mutate(group_mean = mean(spikenorm, na.rm=TRUE)) %>%
        ungroup() %>% 
        mutate(strain = ordered(strain, levels = c("WT", "spt6-1004")))
    
    #rescale data so that mean of WT group is 1
    wt_og_mean = df %>%
        filter(strain=="WT", temperature==30) %>%
        distinct(group_mean) %>%
        pull(group_mean)
    
    df %<>% mutate(spikenorm_scaled = scales::rescale(spikenorm, from=c(0, wt_og_mean)))
    
    summary_df = df %>%
        group_by(strain, temperature) %>% 
        summarise(group_mean_scaled = mean(spikenorm_scaled),
                  group_sd = sd(spikenorm_scaled))
    
    # barplot = ggplot() +
    #     geom_hline(yintercept = 0) +
    #     geom_col(data = summary_df, aes(x=interaction(strain, temperature),
    #                                     y=group_mean_scaled),
    #              color="black", fill=NA, width=0.8) +
    #     geom_errorbar(data = summary_df, aes(x=interaction(strain, temperature),
    #                                          ymax = group_mean_scaled+group_sd,
    #                                          ymin = pmax(group_mean_scaled-group_sd, 0)),
    #                   width = 0.2, size=0.8) +
    #     geom_jitter(data = df, aes(x = interaction(strain, temperature),
    #                               y = spikenorm_scaled,
    #                               color = factor(replicate)),
    #                 width = 0.2, size=2, alpha=0.8) +
    #     geom_text(data = summary_df, aes(x= interaction(strain, temperature),
    #                                      y = -0.1,
    #                                      label = paste(round(group_mean_scaled,2), "%+-%",
    #                                                    round(group_sd, 2))),
    #               parse = TRUE,
    #               size=7/72*25.4) +
    #     scale_x_discrete(labels = c(bquote(WT ~ 30*degree*C),
    #                                 bquote(italic("spt6-1004") ~ 30*degree*C),
    #                                 bquote(WT ~ 37*degree*C),
    #                                 bquote(italic("spt6-1004") ~ 37*degree*C))) +
    #     scale_color_brewer(palette="Set1", name="replicate") +
    #     ggtitle("Spt6 levels normalized to spike-in") +
    #     theme_default +
    #     theme(axis.title = element_blank(),
    #           legend.title = element_text(size=9),
    #           legend.position = c(0.9, 0.9))
    # ggsave('spt6_western_quant.png', plot = barplot, width=10, height=10, units="cm")
    text_edge = 0.3
    increment = (1-text_edge-0.04)/4
    start = increment/2+0.02
    
    align1 = segmentsGrob(x0=text_edge+start,
                          x1=text_edge+start, y0=0, y1=1,
                          gp = gpar(lty="dashed"))
    align2 = segmentsGrob(x0=text_edge+start+increment,
                          x1=text_edge+start+increment, y0=0, y1=1,
                          gp = gpar(lty="dashed"))
    align3 = segmentsGrob(x0=text_edge+start+2*increment,
                          x1=text_edge+start+2*increment, y0=0, y1=1,
                          gp = gpar(lty="dashed"))
    align4 = segmentsGrob(x0=text_edge+start+3*increment,
                          x1=text_edge+start+3*increment, y0=0, y1=1,
                          gp = gpar(lty="dashed"))
    temp_line_one = segmentsGrob(x0=text_edge+start-0.06,
                                 x1=text_edge+start+increment+0.06,
                                 y0=0.785, y1=0.785)
    temp_line_two = segmentsGrob(x0=text_edge+start+2*increment-0.06,
                                 x1=text_edge+start+3*increment+0.06,
                                 y0=0.785, y1=0.785)
    temp_label_one = textGrob(label = expression(30*degree*C),
                              gp = gpar(fontsize = 7),
                              x=text_edge+start+increment/2,
                              y=0.795,
                              vjust=0)
    temp_label_two = textGrob(label = expression(37*degree*C),
                              gp = gpar(fontsize = 7),
                              x=text_edge+start+5/2*increment,
                              y=0.795,
                              vjust=0)
    spt6_label = textGrob(label = "Spt6-FLAG",
                          x = text_edge, y=0.66, gp = gpar(fontsize = 7),
                          hjust=1)
    dst1_label = textGrob(label = "Dst1-Myc",
                          x = text_edge, y=0.495, gp = gpar(fontsize = 7),
                          hjust=1)
    spt6_status = textGrob(label = "Spt6:",
                          x = text_edge, y=0.76, gp = gpar(fontsize = 7),
                          hjust=1)
    plus_one = textGrob(label = "+",
                        x = text_edge+start,
                        y=0.76, gp = gpar(fontsize = 7))
    mutant_one = textGrob(label = "1004",
                          x = text_edge+start+increment,
                          y=0.76,
                          gp = gpar(fontsize = 7,
                                    fontface = "italic"))
    plus_two = textGrob(label = "+",
                        x = text_edge+start+2*increment,
                        y=0.76, gp = gpar(fontsize = 7))
    mutant_two = textGrob(label = "1004",
                          x = text_edge+start+3*increment, y=0.76,
                          gp = gpar(fontsize = 7,
                                    fontface = "italic"))
    blot = rasterGrob(readPNG(blot_path),
                      width=1-text_edge+.02,
                      x=text_edge + (1-text_edge)/2,
                      height=0.37,
                      y=unit(0.58, "npc"))
    spt6_outline = rectGrob(width=1-text_edge-0.04,
                            x=text_edge + (1-text_edge)/2,
                            height=0.15,
                            y=unit(0.66, "npc"),
                            gp=gpar(lwd=1,fill=NA))
    dst_outline = rectGrob(width=1-text_edge-0.04,
                            x=text_edge + (1-text_edge)/2,
                            height=0.15,
                            y=unit(0.495, "npc"),
                            gp=gpar(lwd=1,fill=NA))
    quant_label_one = textGrob(label = expression(textstyle(atop("1.00", phantom(.) %+-% 0.25 ~ phantom(.)))),
                               gp = gpar(fontsize=8),
                               x = text_edge+start,
                               y = 0.365)
    quant_label_two = textGrob(label = expression(textstyle(atop(0.75, phantom(.) %+-% 0.12 ~ phantom(.)))),
                               gp = gpar(fontsize=8),
                               x = text_edge+start+increment,
                               y = 0.365)
    quant_label_three = textGrob(label = expression(textstyle(atop(0.84, phantom(.) %+-% 0.01 ~ phantom(.)))),
                               gp = gpar(fontsize=8),
                               x = text_edge+start+2*increment,
                               y = 0.365)
    quant_label_four = textGrob(label = expression(textstyle(atop(0.19, phantom(.) %+-% 0.05 ~ phantom(.)))),
                               gp = gpar(fontsize=8),
                               x = text_edge+start+3*increment,
                               y = 0.365)
    
    western = gTree(children = gList(
        blot,
        # align1, align2, align3, align4,
        spt6_status, spt6_label, dst1_label,
        plus_one, plus_two,
        mutant_one, mutant_two,
        temp_line_one, temp_line_two,
        temp_label_one, temp_label_two,
        spt6_outline, dst_outline,
        quant_label_one, quant_label_two, quant_label_three, quant_label_four))
    fig_one_b = western %>%
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
