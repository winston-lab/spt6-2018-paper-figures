
import = function(df, path, category){
    df = read_tsv(path) %>%
        mutate(category=category) %>%
        bind_rows(df, .) %>%
        return()
}

main = function(theme_spec,
                tss_genic, tss_intragenic, tss_antisense, tss_intergenic,
                # tfiib_genic, tfiib_intragenic, tfiib_intergenic,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    tss_df = tibble() %>%
        import(tss_genic, "genic") %>%
        import(tss_intragenic, "intragenic") %>%
        import(tss_antisense, "antisense") %>%
        import(tss_intergenic, "intergenic") %>%
        mutate(category=fct_inorder(category, ordered=TRUE)) %>%
        select(peak_name, condition_expr, control_expr, category) %>%
        gather(key=condition, value=expression, -c(peak_name, category)) %>%
        mutate(condition = ordered(condition,
                                   levels = c("control_expr", "condition_expr"),
                                   labels = c("WT-37C", "spt6-1004-37C")))

    # tfiib_df = tibble() %>%
    #     import(tfiib_genic, "genic") %>%
    #     import(tfiib_intragenic, "intragenic") %>%
    #     import(tfiib_intergenic, "intergenic") %>%
    #     mutate(category=fct_inorder(category, ordered=TRUE)) %>%
    #     select(peak_name, condition_expr, control_expr, category) %>%
    #     gather(key=condition, value=expression, -c(peak_name, category)) %>%
    #     mutate(condition = ordered(condition,
    #                                levels = c("control_expr", "condition_expr"),
    #                                labels = c("WT-37C", "spt6-1004-37C")))

    tss_plot = ggplot(data = tss_df,
                      aes(x=category, y=expression+1,
                          group=interaction(condition, category))) +
        geom_violin(aes(fill=condition),
                    bw = .05,
                    position=position_dodge(width=0.6),
                    size=0.2) +
        geom_boxplot(position=position_dodge(width=0.6),
                     width=0.1, notch=TRUE, outlier.size=0, outlier.stroke=0,
                     size=0.2) +
        scale_x_discrete(expand = c(0,0),
                         limits = c("genic", "intragenic", "antisense", "intergenic", "")) +
        scale_y_log10(name = "normalized counts",
                      breaks = c(10, 1000), labels = c(bquote(10^1), bquote(10^3))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
                        # guide=guide_legend(label.position="top",
                        #                    label.hjust=0.5,
                        #                    keywidth=unit(30, "pt"),
                        #                    keyheight=unit(10, "pt"))) +
        ggtitle("expression level of TSS-seq peaks") +
        theme_default +
        theme(axis.title.x = element_blank(),
              panel.border = element_blank(),
              panel.grid.major.x = element_blank(),
              legend.position = c(1, 1),
              # legend.justification = c(0.5, 0.5),
              legend.key.width = unit(8, "pt"))

    # tfiib_plot = ggplot(data = tfiib_df,
    #                     aes(x=category, y=expression+1,
    #                         group=interaction(condition, category))) +
    #     geom_violin(aes(fill=condition),
    #                 bw = .06,
    #                 position=position_dodge(width=0.6),
    #                 size=0.2) +
    #     geom_boxplot(position=position_dodge(width=0.6),
    #                  width=0.1, notch=TRUE, outlier.size=0, outlier.stroke=0,
    #                  size=0.1) +
    #     scale_x_discrete(limits = c("genic", "intragenic", "intergenic", "")) +
    #     scale_y_log10(name = "normalized counts",
    #                   breaks = c(10, 1000), labels = c(bquote(10^1), bquote(10^3))) +
    #     scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
    #     ggtitle("signal at TFIIB ChIP-nexus peaks") +
    #     theme_default +
    #     theme(axis.title.x = element_blank(),
    #           axis.title.y = element_text(size=5),
    #           axis.text.y = element_text(size=5),
    #           legend.position = c(0.98, 0.98),
    #           legend.background= element_rect(fill="white", size=0),
    #           legend.text = element_text(size=7),
    #           legend.key.size=unit(8, "pt"),
    #           legend.margin = margin(0,0,0,0),
    #           plot.title = element_text(size=7, margin=margin(0,0,0,0)))


    # fig_one_e = arrangeGrob(tss_plot, tfiib_plot, ncol=1, heights = c(1, 1)) %>%
    fig_one_e = tss_plot %>%
        add_label("E")

    ggsave(svg_out, plot=fig_one_e, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_e, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_e, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_e, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     tss_genic = snakemake@input[["tss_genic"]],
     tss_intragenic = snakemake@input[["tss_intragenic"]],
     tss_antisense = snakemake@input[["tss_antisense"]],
     tss_intergenic = snakemake@input[["tss_intergenic"]],
     # tfiib_genic = snakemake@input[["tfiib_genic"]],
     # tfiib_intragenic = snakemake@input[["tfiib_intragenic"]],
     # tfiib_intergenic = snakemake@input[["tfiib_intergenic"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

