
main = function(theme_spec, data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

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
        # geom_label(data = df %>%
        #                group_by(gene) %>%
        #                summarise(y = max(value)) %>%
        #                mutate(label = if_else(gene=="SSA4",
        #                                       "italic(\"SSA4\")",
        #                                       "italic(\"HSP12\")")),
        #            aes(y=y, label=label),
        #            x=1, parse=TRUE) +
        facet_wrap(~gene,
                   nrow=1,
                   scales = "free") +
        scale_color_tableau(guide = guide_legend(label.position = "bottom",
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
        theme(legend.position = c(0.02, 0.9),
              legend.direction = "horizontal",
              legend.justification = c(0, 1),
              legend.key.height=unit(3, "pt"),
              legend.key.width=unit(11, "pt"),
              panel.grid = element_blank(),
              axis.text.x = element_text(),
              axis.title.x = element_blank(),
              strip.text = element_text(size=7, color="black", hjust=0,
                                        face="italic"),
              legend.title = element_text(size=7, color="black"),
              plot.margin = margin(0,0,2,0,"pt"))

    fig_six_c = arrangeGrob(textGrob(label = "Western"),
                            barplot, ncol=1, heights=c(0.3, 1)) %>%
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
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
