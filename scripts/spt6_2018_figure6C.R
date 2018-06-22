
main = function(theme_spec,
                spt6_blot_path, pgk1_blot_path,
                data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(png)

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
    proteasome_left = linesGrob(x = c(0.612, 0.612),
                                y = c(0.31, 0.79))
    proteasome_right = linesGrob(x = c(0.718, 0.718),
                                y = c(0.31, 0.79))
    proteasome_body = rectGrob(hjust=0.5, vjust=0,
                               x=0.665, y=0.31,
                               height=0.48, width=0.106,
                               gp = gpar(fill="#acd65b", lwd=NA))
    proteasome_body_two = rectGrob(hjust=0.5, vjust=0,
                               x=0.665, y=0.408,
                               height=0.1, width=0.106,
                               gp = gpar(fill="#acd65b", lwd=NA))
    proteasome_body_three = rectGrob(hjust=0.5, vjust=0,
                               x=0.665, y=0.702,
                               height=0.1, width=0.106,
                               gp = gpar(fill="#acd65b", lwd=NA))
    proteasome_text = textGrob(label = "proteasome",
                               x = 0.65, y=0.98, hjust=0, vjust=1,
                               gp = gpar(fontsize=7))
    arc_one = curveGrob(x1=0.45, y1=0.8, x2=0.63, y2=0.87,
                        square=FALSE, curvature=-0.5, ncp=10,
                        arrow = arrow(length=unit(0.07, "npc")))
    arc_two = curveGrob(x1=0.7, y1=0.24, x2=0.88, y2=0.31,
                        square=FALSE, curvature=0.5, ncp=10,
                        arrow = arrow(length=unit(0.07, "npc")))
    pep_one = ellipseGrob(x=0.88, y=0.5, size=0.6,
                          gp = gpar(fill="#75d7f9"))
    pep_two = ellipseGrob(x=0.84, y=0.6, size=0.6,
                          gp = gpar(fill="#fbb03b"))
    pep_three = ellipseGrob(x=0.86, y=0.4, size=0.6,
                          gp = gpar(fill="#fbb03b"))
    pep_four = ellipseGrob(x=0.89, y=0.64, size=0.6,
                          gp = gpar(fill="#fbb03b"))
    pep_five = ellipseGrob(x=0.90, y=0.42, size=0.6,
                          gp = gpar(fill="#fbb03b"))
    pep_six = ellipseGrob(x=0.93, y=0.58, size=0.6,
                          gp = gpar(fill="#fbb03b"))
    pep_seven = ellipseGrob(x=0.95, y=0.46, size=0.6,
                          gp = gpar(fill="#fbb03b"))
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
                                     pep_one, pep_two, pep_three, pep_four,
                                     pep_five, pep_six, pep_seven))

    #western blot
    dmso_label = textGrob(label="DMSO",
                          x=0.292, y=0.98,
                          vjust=1,
                          gp=gpar(fontsize=7))
    iaa_label = textGrob(label="IAA",
                          x=0.58, y=0.98,
                          vjust=1,
                          gp=gpar(fontsize=7))


    dmso_t15 = textGrob(label = "15",
                        x=0.292, y=0.85, vjust=1,
                        gp=gpar(fontsize=7))
    dmso_t0 = textGrob(label = "0",
                        x=0.197, y=0.85, vjust=1,
                        gp=gpar(fontsize=7))
    dmso_t80 = textGrob(label = "80",
                        x=0.387, y=0.85, vjust=1,
                        gp=gpar(fontsize=7))
    iaa_t15 = textGrob(label = "15",
                        x=0.58, y=0.85, vjust=1,
                        gp=gpar(fontsize=7))
    iaa_t0 = textGrob(label = "0",
                        x=0.485, y=0.85, vjust=1,
                        gp=gpar(fontsize=7))
    iaa_t80 = textGrob(label = expression(80 ~ min ~ at ~ 37*degree*C),
                        x=0.648, y=0.85, hjust=0, vjust=0.95,
                        gp=gpar(fontsize=7))

    pgk1_blot = rasterGrob(readPNG(pgk1_blot_path),
                      width=0.78, x=0.482,
                      height=0.2, y=0.26,
                      vjust=0.57)
    pgk1_outline = rectGrob(width=0.65, x=0.11,
                            height=0.3, y=0.26,
                            hjust=0, vjust=0.5,
                            gp=gpar(lwd=0.5,fill=NA))
    spt6_blot = rasterGrob(readPNG(spt6_blot_path),
                      width=0.79, x=0.482,
                      height=0.2, y=0.57,
                      vjust=0.5)
    spt6_outline = rectGrob(width=0.65, x=0.11,
                            height=0.3, y=0.59,
                            hjust=0, vjust=0.5,
                            gp=gpar(lwd=0.5,fill=NA))
    spt6_label = textGrob(label="Spt6-AID",
                          x=0.77, y=0.59,
                          hjust=0, vjust=0.5,
                          gp=gpar(fontsize=7))
    pgk1_label = textGrob(label="Pgk1",
                          x=0.77, y=0.26,
                          hjust=0, vjust=0.5,
                          gp=gpar(fontsize=7))
    dmso_line = linesGrob(x=c(0.157, 0.407), y=c(0.87, 0.87))
    iaa_line = linesGrob(x=c(0.455, 0.705), y=c(0.87, 0.87))
    align = linesGrob(x=c(0.485, 0.485), y=c(0,1))
    western = gTree(children = gList(spt6_blot, pgk1_blot,
                                     spt6_outline, pgk1_outline,
                                     dmso_label, iaa_label,
                                     dmso_line, iaa_line,
                                     dmso_t15, iaa_t15,
                                     dmso_t80, iaa_t80,
                                     dmso_t0, iaa_t0,
                                     spt6_label, pgk1_label))

    #rt-qpcr
    df = read_tsv(data_path,
                  col_types = 'ccid') %>%
        mutate(strain = ordered(strain,
                                levels = c("spt6-AID2 DMSO", "spt6-AID2 IAA"),
                                labels = c("+DMSO", "+IAA")))

    summary_df = df %>%
        group_by(strain, gene, time) %>%
        summarise(mean = mean(value),
                  sd = sd(value)) %>%
        mutate(high = mean+sd,
               low = mean-sd)

    barplot = ggplot() +
        geom_col(data = summary_df,
                 aes(x=strain, y=mean, group=time),
                 fill = "grey90",
                 position = position_dodge(width=0.5),
                 width=0.4,
                 color="black") +
        geom_errorbar(data = summary_df,
                      aes(ymax=high, ymin=pmax(0,low),
                          x=strain, group=time),
                      position = position_dodge(width=0.5),
                      width = 0.2) +
        geom_point(data = df,
                   aes(x=strain, y=value, color=factor(time)),
                   position = position_jitterdodge(dodge.width=0.5,
                                                   jitter.width= 0.3),
                   size = 0.7) +
        geom_label(data = df %>%
                       group_by(gene) %>%
                       summarise(y = max(value)) %>%
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
                            name = expression(minutes ~ at ~ 37*degree*C)) +
        scale_x_discrete(expand = c(0,0.3)) +
        scale_y_continuous(limits = c(0, NA),
                           expand = c(0.03,0),
                           name = "relative abundance",
                           breaks = scales::pretty_breaks(n=2)) +
        theme_default +
        theme(legend.position = c(0.02, 0.88),
              legend.direction = "horizontal",
              legend.justification = c(0, 1),
              legend.key.height=unit(3, "pt"),
              legend.key.width=unit(11, "pt"),
              panel.grid = element_blank(),
              axis.text.x = element_text(),
              axis.title.x = element_blank(),
              # strip.text = element_text(size=7, color="black", hjust=0,
              #                           face="italic"),
              legend.title = element_text(size=7, color="black"),
              plot.margin = margin(0,0,2,0,"pt"))

    fig_six_c = arrangeGrob(diagram, western,
                            barplot, layout_matrix = rbind(c(1,2),
                                                           c(3,3),
                                                           c(3,3))) %>%
        add_label("C")

# fig_six_c = ggplot() +
#     # geom_ribbon(data = summary_df, aes(x=time, ymax=high, ymin=pmax(0, low), fill=strain),
#     #             alpha=0.2) +
#     geom_line(data = summary_df, aes(x=time, y=mean, color=strain),
#               position = position_dodge(width=5),
#               size=1.5, alpha=0.9) +
#     geom_errorbar(data = summary_df, aes(x=time, ymax=high, ymin=pmax(0,low), color=strain),
#                   position = position_dodge(width=5), width=5, alpha=0.9, size=0.5) +
#     geom_label(data = tibble(gene = c("SSA4", "HSP12"),
#                              y = c(df %>% filter(gene == "SSA4") %>% pull(value) %>% max(),
#                                    df %>% filter(gene == "HSP12") %>% pull(value) %>% max())),
#                aes(y=y, label=gene),
#                x=0, size=9/72*25.4,
#                label.size = NA, label.r = unit(0, "pt"), vjust=1, hjust=0) +
#     geom_point(data = df,
#        aes(x=time, y=value, color=strain),
#        position = position_jitterdodge(dodge.width=5),
#        alpha=0.75, size=0.8) +
#     facet_grid(gene~., scales="free_y") +
#     scale_x_continuous(limits = c(-3, 85),
#                        expand = c(0,0),
#                        name = expression("minutes at" ~ 37*degree*C)) +
#     scale_y_continuous(name = "relative abundance") +
#     scale_color_tableau() +
#     theme_default +
#     theme(legend.position = c(0.5, 0.90))

    ggsave(svg_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     spt6_blot_path = snakemake@input[["spt6_blot_path"]],
     pgk1_blot_path = snakemake@input[["pgk1_blot_path"]],
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

