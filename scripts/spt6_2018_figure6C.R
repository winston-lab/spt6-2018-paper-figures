
main = function(theme_spec,
                blot_path,
                western_data_path,
                qpcr_data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(png)

    df = read_tsv(western_data_path) %>%
        select(1,2,3,4,5,18,19,20,21,22) %>%
        magrittr::set_colnames(c("temperature", "time", "condition", "replicate", "antigen",
                               "gray_min", "gray_max", "gray_mean", "gray_median", "integrated_density")) %>%
        select(temperature, time, condition, replicate, antigen, integrated_density)

    bg_df = df %>% filter(antigen=="background")

    df %<>%
        filter(antigen != "background") %>%
        left_join(bg_df, by=c("temperature", "time", "condition", "replicate")) %>%
        mutate(norm_signal = integrated_density.x-integrated_density.y) %>%
        select(-c(integrated_density.x, integrated_density.y, antigen.y)) %>%
        rename(antigen = antigen.x) %>%
        group_by(temperature, time, condition) %>%
        spread(antigen, norm_signal) %>%
        mutate(norm_signal = Spt6/Pgk1) %>%
        group_by(temperature, time, condition) %>%
        mutate(group_mean = mean(norm_signal, na.rm=TRUE))

    #rescale data so that mean of WT group is 1
    wt_og_mean = df %>%
        filter(condition=="DMSO", time==0, temperature==30) %>%
        distinct(group_mean) %>%
        pull(group_mean)

    df %<>%
        mutate(norm_scaled = scales::rescale(norm_signal, from=c(0, wt_og_mean)))

    summary_df = df %>%
        group_by(temperature, time, condition) %>%
        summarise(group_mean_scaled = mean(norm_scaled, na.rm=TRUE),
                  group_sd = sd(norm_scaled, na.rm=TRUE))
    print(summary_df)

    # barplot = ggplot() +
    #     geom_hline(yintercept = 0) +
    #     geom_col(data = summary_df, aes(x=interaction(condition, temperature),
    #                                     y=group_mean_scaled,
    #                                     group = time),
    #              position = position_dodge(width=0.8),
    #              color="black", fill=NA, width=0.8) +
    #     geom_errorbar(data = summary_df, aes(x=interaction(condition, temperature),
    #                                          ymax = group_mean_scaled+group_sd,
    #                                          ymin = pmax(group_mean_scaled-group_sd, 0),
    #                                          group = time),
    #                   position = position_dodge(width=0.8),
    #                   width = 0.2, size=0.8) +
    #     geom_point(data = df, aes(x = interaction(condition, temperature),
    #                               y = norm_scaled,
    #                               group = time,
    #                               color = factor(time),
    #                               shape = factor(replicate)),
    #                position = position_jitterdodge(dodge.width=0.8),
    #                size=2, alpha=0.8) +
    #     geom_text(data = summary_df, aes(x= interaction(condition, temperature),
    #                                      y = -0.1,
    #                                      group = time,
    #                                      label = paste("atop(", round(group_mean_scaled,2), ", phantom(.)", "%+-%",
    #                                                    round(group_sd, 2), "~ phantom(.))")),
    #               parse = TRUE,
    #               position = position_dodge(width=0.8),
    #               size=7/72*25.4) +
    #     scale_color_gdocs(name = "minutes", na.value="black") +
    #     ggtitle("Spt6 levels normalized to Pgk1") +
    #     theme_default +
    #     theme(axis.title = element_blank(),
    #           legend.title = element_text(size=9),
    #           legend.position = c(0.9, 0.9))
    # ggsave('spt6_depletion_western_quant.png', plot = barplot, width=20, height=10, units="cm")


    #diagram
    spt6_ellipse = ellipseGrob(x=0.27, y=0.45,
                               size=4.5, ar=2.5, angle=0,
                               gp = gpar(lwd=1, fill="#fbb03b"))
    spt6_ellipse_text = textGrob(label = "Spt6",
                                 x=0.27, y=0.45,
                                 gp = gpar(fontsize=7))
    aid_ellipse = ellipseGrob(x=0.4, y=0.68,
                              size=2.2, ar=1.3, angle=0,
                              gp = gpar(lwd=1, fill="#75d7f9"))
    aid_ellipse_text = textGrob(label = "AID",
                                x = 0.4, y=0.68,
                                gp = gpar(fontsize=7))
    linker = linesGrob(x = c(0.27, 0.4),
                       y = c(0.45, 0.68))
    iaa_text = textGrob(label = "+IAA",
                        x=0.515, y=0.81,
                        gp = gpar(fontsize=7))
    proteasome_top = ellipseGrob(x=0.665, y=0.79,
                                 ar=2.5, size=1.7, angle=0,
                                 gp = gpar(fill="#acd65b"))
    proteasome_topmid = ellipseGrob(x=0.665, y=0.702,
                                 ar=2.5, size=1.7, angle=0,
                                 gp = gpar(fill="#acd65b"))
    proteasome_botmid = ellipseGrob(x=0.665, y=0.408,
                                 ar=2.5, size=1.7, angle=0,
                                 gp = gpar(fill="#acd65b"))
    proteasome_bottom = ellipseGrob(x=0.665, y=0.31,
                                 ar=2.5, size=1.7, angle=0,
                                 gp = gpar(fill="#acd65b"))
    proteasome_left = linesGrob(x = c(0.60, 0.60),
                                y = c(0.31, 0.79))
    proteasome_right = linesGrob(x = c(0.73, 0.73),
                                y = c(0.31, 0.79))
    proteasome_body = rectGrob(hjust=0.5, vjust=0,
                               x=0.665, y=0.31,
                               height=0.48, width=0.130,
                               gp = gpar(fill="#acd65b", lwd=NA))
    proteasome_body_two = rectGrob(hjust=0.5, vjust=0,
                               x=0.665, y=0.408,
                               height=0.1, width=0.130,
                               gp = gpar(fill="#acd65b", lwd=NA))
    proteasome_body_three = rectGrob(hjust=0.5, vjust=0,
                               x=0.665, y=0.702,
                               height=0.1, width=0.130,
                               gp = gpar(fill="#acd65b", lwd=NA))
    proteasome_text = textGrob(label = "proteasome",
                               x = 0.65, y=0.98, hjust=0, vjust=1,
                               gp = gpar(fontsize=7))
    arc_one = curveGrob(x1=0.42, y1=0.81, x2=0.63, y2=0.87,
                        square=FALSE, curvature=-0.6, ncp=10,
                        arrow = arrow(length=unit(0.07, "npc")))
    arc_two = curveGrob(x1=0.69, y1=0.23, x2=0.88, y2=0.31,
                        square=FALSE, curvature=0.6, ncp=10,
                        arrow = arrow(length=unit(0.07, "npc")))
    peptides = ellipseGrob(x=c(0.88, 0.84, 0.86, 0.89, 0.90, 0.93, 0.95),
                           y=c(0.50, 0.60, 0.40, 0.64, 0.42, 0.58, 0.46),
                           size=0.6,
                           gp = gpar(fill=c("#75d7f9", rep("#fbb03b", 6))))
    diagram = gTree(children = gList(linker,
                                     spt6_ellipse, spt6_ellipse_text,
                                     aid_ellipse, aid_ellipse_text,
                                     iaa_text, arc_one, arc_two,
                                     proteasome_bottom, proteasome_body,
                                     proteasome_botmid, proteasome_body_two,
                                     proteasome_topmid, proteasome_body_three,
                                     proteasome_top,
                                     proteasome_left, proteasome_right,
                                     proteasome_text,
                                     peptides))

    #western blot
    right_align = 0.83
    increment = (right_align-0.04)/10
    start = increment/2+0.02

    blot = rasterGrob(readPNG(blot_path),
                      width=right_align+0.02, x=right_align/2+0.002,
                      height=0.55, y=0.42,
                      hjust=0.5,
                      vjust=0.5)
    pgk1_outline = rectGrob(width=right_align-0.04, x=right_align/2,
                            height=0.175, y=0.305,
                            gp=gpar(lwd=0.5,fill=NA))
    # spt6_blot = rasterGrob(readPNG(spt6_blot_path),
    #                   width=right_align+0.01, x=right_align/2,
    #                   height=0.2, y=0.54,
    #                   hjust=0.46,
    #                   vjust=0.5)
    spt6_outline = rectGrob(width=right_align-0.04, x=right_align/2,
                            height=0.175, y=0.545,
                            gp=gpar(lwd=0.5,fill=NA))

    min_at_temp = textGrob(label = "min at temp.",
                           x=start+9*increment+0.025,
                           y=0.695,
                           hjust=0,
                           gp = gpar(fontsize=6))
    time_labels = textGrob(label = c(0, 20, 80, 0, 20, 80, 20, 80, 20, 80),
                        x=seq(start, start+9*increment, increment),
                        y=0.70,
                        gp=gpar(fontsize=7))
    condition_lines = segmentsGrob(x0 = start+c(0, 3, 6, 8)*increment-0.01,
                                   x1 = start+c(2, 5, 7, 9)*increment+0.01,
                                   y0 = 0.76, y1=0.76,
                                   gp = gpar(lwd = 0.5))
    condition_labels = textGrob(label = c("DMSO", "IAA", "DMSO", "IAA"),
                                x = start+c(1,4,6.5,8.5)*increment,
                                y = 0.82,
                                gp = gpar(fontsize=7))
    temperature_lines = segmentsGrob(x0 = start+c(0, 6)*increment-0.01,
                                   x1 = start+c(5, 9)*increment+0.01,
                                   y0 = 0.88, y1=0.88,
                                   gp = gpar(lwd=0.5))
    temperature_labels = textGrob(label = c(expression(37*degree*C), expression(30*degree*C)),
                                x = start+c(2.5, 7.5)*increment,
                                y = 0.94,
                                gp = gpar(fontsize=7))
    summary_df %<>%
        filter(! is.na(time)) %>%
        arrange(temperature, condition, time) %>%
        mutate(mean_label = sprintf("%.2f", round(group_mean_scaled, 2)),
               sd_label = sprintf("%.2f", round(group_sd, 2)))

    quant_labels = textGrob(label =  c(expression(textstyle(atop("1.00", phantom(.) %+-% 0.47 ~  phantom(.)))),
                                       expression(textstyle(atop(0.99, phantom(.) %+-% 0.08 ~  phantom(.)))),
                                       expression(textstyle(atop(0.96, phantom(.) %+-% 0.33 ~  phantom(.)))),
                                       expression(textstyle(atop(0.25, phantom(.) %+-% 0.02 ~  phantom(.)))),
                                       expression(textstyle(atop(0.24, phantom(.) %+-% 0.06 ~  phantom(.)))),
                                       expression(textstyle(atop(0.49, phantom(.) %+-% 0.17 ~  phantom(.)))),
                                       expression(textstyle(atop(0.95, phantom(.) %+-% 0.22 ~  phantom(.)))),
                                       expression(textstyle(atop(0.92, phantom(.) %+-% 0.25 ~  phantom(.)))),
                                       expression(textstyle(atop(0.14, phantom(.) %+-% 0.02 ~  phantom(.)))),
                                       expression(textstyle(atop(0.07, phantom(.) %+-% 0.05 ~  phantom(.))))),
                        x=seq(start, start+9*increment, increment),
                        y=0.10, gp=gpar(fontsize=7))

    spt6_label = textGrob(label="Spt6-AID",
                          x=right_align-0.01, y=0.545,
                          hjust=0,
                          gp=gpar(fontsize=7))
    pgk1_label = textGrob(label="Pgk1",
                          x=right_align-0.01, y=0.305,
                          hjust=0,
                          gp=gpar(fontsize=7))
    western = gTree(children = gList(blot,
                                     spt6_outline, pgk1_outline,
                                     time_labels,
                                     min_at_temp,
                                     condition_lines,
                                     condition_labels,
                                     temperature_lines,
                                     temperature_labels,
                                     quant_labels,
                                     spt6_label, pgk1_label))

    # ggsave("test.pdf", plot=western, width=6.09, height=2.22, units="cm")

    #rt-qpcr
    df = read_tsv(qpcr_data_path,
                  col_types = 'cciid') %>%
        mutate(strain = ordered(strain,
                                levels = c("spt6-AID2 IAA", "spt6-AID2 DMSO"),
                                labels = c("+IAA", "+DMSO")))

    summary_df = df %>%
        group_by(strain, gene, temperature, time) %>%
        summarise(mean = mean(value, na.rm=TRUE),
                  sd = sd(value, na.rm=TRUE)) %>%
        mutate(high = mean+sd,
               low = mean-sd)

    # lineplot = ggplot() +
    #     geom_label(data = df %>%
    #                    group_by(gene) %>%
    #                    summarise(y = max(value, na.rm=TRUE)) %>%
    #                    bind_rows(summary_df %>%
    #                                  group_by(gene) %>%
    #                                  summarise(y = max(high))) %>%
    #                    group_by(gene) %>%
    #                    summarise(y = max(y)) %>%
    #                    mutate(label = if_else(gene=="SSA4",
    #                                           "italic(\"SSA4\")",
    #                                           "italic(\"HSP12\")")),
    #                aes(y=y, label=label),
    #                parse=TRUE,
    #                x=-3, size=7/72*25.4,
    #                label.size = NA, label.r = unit(0, "pt"), vjust=1, hjust=0) +
    #     geom_line(data = summary_df %>%
    #                   bind_rows(summary_df %>%
    #                                 filter(temperature==30, time==0) %>%
    #                                 ungroup() %>%
    #                                 mutate(temperature=as.integer(37))),
    #              aes(x=time, y=mean, color=factor(temperature), linetype=strain,
    #                  group = interaction(temperature, strain)),
    #              position=position_dodge(width=5)) +
    #     geom_errorbar(data = summary_df %>%
    #                       bind_rows(summary_df %>%
    #                                     filter(temperature==30, time==0) %>%
    #                                     ungroup() %>%
    #                                     mutate(temperature=as.integer(37))),
    #                   aes(x=time, ymax=high, ymin=pmax(0,low),
    #                       color=factor(temperature),
    #                       group=interaction(temperature, strain)),
    #                   position = position_dodge(width=5),
    #                   width=5, alpha=0.9, size=0.5) +
    #     geom_point(data = df,
    #                aes(x=time, y=value, color=factor(temperature),
    #                    shape = interaction(temperature, strain)),
    #                position = position_jitterdodge(dodge.width=5),
    #                alpha=0.9, size=0.8) +
    #     scale_color_tableau(labels = c(bquote(30*degree*C),
    #                                    bquote(37*degree*C)),
    #                         guide=guide_legend(reverse=TRUE)) +
    #     # scale_linetype_discrete(labels = c("+IAA (Spt6 depletion)",
    #     #                                    "+DMSO (no depletion)")) +
    #     scale_x_continuous(limits = c(-3, 85),
    #                        breaks = c(0, 20, 80),
    #                        expand = c(0,0),
    #                        name = "minutes at temperature") +
    #     scale_y_continuous(name = "relative abundance",
    #                        breaks = scales::pretty_breaks(n=2)) +
    #     scale_shape_discrete(guide=FALSE) +
    #     # facet_grid(gene~., scales="free_y") +
    #     facet_wrap(~gene, nrow=1, scales="free_y") +
    #     theme_default +
    #     theme(legend.position = c(0.45, 0.99),
    #           panel.grid.major = element_blank(),
    #           panel.grid.minor = element_blank(),
    #           legend.justification = c(1,1),
    #           legend.box = "vertical",
    #           legend.spacing.y = unit(1, "pt"),
    #           plot.margin = margin(-2,0,0,0,"pt"))

    expandby = 1.05
    placeholder = df %>%
        distinct(temperature, strain, gene) %>%
        mutate(y = c(rep(3.56*expandby, 4),
                     rep(1.04*expandby, 4)))

    barplot = ggplot() +
        geom_col(data = summary_df,
                 aes(x=interaction(temperature, strain) %>%
                         ordered(levels = c("30.+DMSO", "30.+IAA", "37.+DMSO", "37.+IAA")),
                     y=mean, group=time),
                 # fill = "grey90",
                 fill = NA,
                 position = position_dodge(width=0.5),
                 width=0.4, size=0.2,
                 color="black") +
        facet_wrap(~gene,
                   nrow=1,
                   scales = "free") +
        geom_errorbar(data = summary_df,
                      aes(ymax=high, ymin=pmax(0,low),
                          x=interaction(temperature, strain) %>%
                              ordered(levels = c("30.+DMSO",
                                                 "30.+IAA",
                                                 "37.+DMSO",
                                                 "37.+IAA")),
                          group=time),
                      position = position_dodge(width=0.5),
                      width = 0.2, alpha=0.9, size=0.4) +
        geom_point(data = df,
                   aes(x=interaction(temperature, strain) %>%
                           ordered(levels = c("30.+DMSO", "30.+IAA", "37.+DMSO", "37.+IAA")),
                       y=value, color=factor(time)),
                   position = position_jitterdodge(dodge.width=0.5,
                                                   jitter.width= 0.3),
                   size = 0.7, alpha=0.9) +
        geom_point(data = placeholder,
                   aes(x=interaction(temperature, strain) %>%
                           ordered(levels = c("30.+DMSO", "30.+IAA", "37.+DMSO", "37.+IAA")),
                       y=y),
                   size=0, stroke=0) +
        geom_label(data = df %>%
                       group_by(gene) %>%
                       summarise(y = max(value, na.rm=TRUE)) %>%
                       bind_rows(summary_df %>%
                                     group_by(gene) %>%
                                     summarise(y = max(high))) %>%
                       group_by(gene) %>%
                       summarise(y = max(y)) %>%
                       mutate(label = if_else(gene=="SSA4",
                                              "italic(\"SSA4\")",
                                              "italic(\"HSP12\")")),
                   aes(y=y, label=label),
                   x=0.75, parse=TRUE, hjust=0, vjust=0.8,
                   label.size=NA, size=7/72*25.4) +
        facet_wrap(~gene,
                   nrow=1,
                   scales = "free") +
        scale_color_gdocs(guide = guide_legend(label.position = "bottom",
                                               label.hjust=0.5,
                                               title.position = "top",
                                               title.hjust=0.5),
                            name = expression(minutes)) +
        scale_x_discrete(labels = c(bquote(textstyle(atop(30*degree*C, +DMSO))),
                                    bquote(textstyle(atop(30*degree*C, +IAA))),
                                    bquote(textstyle(atop(37*degree*C, +DMSO))),
                                    bquote(textstyle(atop(37*degree*C, +IAA)))),
                         expand = c(0,0.3)) +
        scale_y_continuous(limits = c(0, NA),
                           expand = c(0,0),
                           name = "relative abundance",
                           breaks = scales::pretty_breaks(n=2)) +
        theme_default +
        theme(legend.position = c(0.02, 0.78),
              legend.direction = "horizontal",
              legend.justification = c(0, 1),
              legend.key.height=unit(3, "pt"),
              legend.key.width=unit(11, "pt"),
              panel.grid = element_blank(),
              axis.text.x = element_text(size=8),
              axis.title.x = element_blank(),
              # strip.text = element_text(size=7, color="black", hjust=0,
              #                           face="italic"),
              legend.title = element_text(size=7, color="black"),
              plot.margin = margin(4,0,0,0,"pt"))

    fig_six_c = arrangeGrob(diagram, western,
                            barplot, layout_matrix = rbind(c(1,1,2,2,2),
                                                           c(3,3,3,3,3),
                                                           c(3,3,3,3,3))) %>%
        add_label("C")

    ggsave(svg_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     blot_path = snakemake@input[["blot_path"]],
     western_data_path = snakemake@input[["western_data_path"]],
     qpcr_data_path = snakemake@input[["qpcr_data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
