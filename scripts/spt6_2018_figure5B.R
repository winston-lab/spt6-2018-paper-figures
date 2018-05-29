
main = function(theme_spec,
                annotation,
                cluster_one, cluster_two, tss_diffexp, tfiib_diffbind,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(cowplot)

    df = read_tsv(cluster_one,
                  col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
        # mutate(cluster=paste0("cluster 1 (", n(), " TSSs)")) %>%
        mutate(cluster="cluster 1") %>%
        bind_rows(read_tsv(cluster_two,
                       col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
                      # mutate(cluster=paste0("cluster 2 (", n(), " TSSs)"))) %>%
                      mutate(cluster="cluster 2")) %>%
        select(name, cluster) %>%
        left_join(read_tsv(tss_diffexp),
                  by=c("name"="peak_name")) %>%
        select(name, cluster, tss_condition=condition_expr,
               tss_control=control_expr, atg_to_peak_dist) %>%
        left_join(read_tsv(tfiib_diffbind),
                  by=c("name"="tss_id")) %>%
        select(name, cluster, tss_cond_levels=tss_condition, tss_ctrl_levels=tss_control,
               atg_to_peak_dist, tss_lfc, tss_logq, tfiib_lfc,
               tfiib_logq, tfiib_cond_levels, tfiib_ctrl_levels)

    tss_levels_df = df %>%
        select(name, cluster, tss_cond_levels, tss_ctrl_levels) %>%
        gather(key=group, value=tss_levels, -c(name, cluster)) %>%
        mutate(group = ordered(group,
                               levels = c("tss_ctrl_levels","tss_cond_levels"),
                               labels = c("WT", "spt6-1004")))
    tfiib_levels_df = df %>%
        select(name, cluster, tfiib_cond_levels, tfiib_ctrl_levels) %>%
        gather(key=group, value=tfiib_levels, -c(name, cluster)) %>%
        mutate(group = ordered(group,
                               levels = c("tfiib_ctrl_levels","tfiib_cond_levels"),
                               labels = c("WT", "spt6-1004")))

    tss_plot = ggplot(data = tss_levels_df, aes(x=cluster, y=tss_levels+1)) +
        geom_violin(aes(fill=group),
                    position=position_dodge(width=0.5),
                    size=0.2) +
        geom_boxplot(aes(group = interaction(cluster, group)),
                     position=position_dodge(width=0.5),
                     width=0.1, size=0.2,
                     outlier.size=0, outlier.stroke=0, notch=TRUE) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_x_discrete(expand=c(0,0)) +
        scale_y_log10(name = "normalized counts",
                      breaks = c(10, 1000),
                      labels = c(bquote(10^1), bquote(10^3))) +
        ggtitle("TSS-seq signal") +
        theme_default +
        theme(axis.title.x = element_blank(),
              axis.text.x = element_blank(),
              legend.position = c(0.55, 1),
              legend.justification = c(0.5, 0.9),
              legend.key.size = unit(5, "pt"),
              legend.text = element_text(size=5),
              plot.margin = margin(0,0,0,8,"pt"),
              plot.title = element_text(size=5, margin = margin(0,0,0,0)),
              axis.text.y = element_text(size=5),
              axis.title.y = element_text(size=5))

    tfiib_plot = ggplot(data = tfiib_levels_df, aes(x=cluster, y=tfiib_levels+1)) +
        geom_violin(aes(fill=group),
                    position=position_dodge(width=0.5),
                    size=0.2) +
        geom_boxplot(aes(group = interaction(cluster, group)),
                     position=position_dodge(width=0.5),
                     width=0.1, size=0.2,
                     outlier.size=0, outlier.stroke=0, notch=TRUE) +
        scale_fill_ptol() +
        scale_color_ptol() +
        scale_x_discrete(expand=c(0,0)) +
        scale_y_log10(name = "normalized counts",
                      breaks = c(10, 1000),
                      labels = c(bquote(10^1), bquote(10^3))) +
        ggtitle("TFIIB ChIP-nexus signal") +
        theme_default +
        theme(axis.title.x = element_blank(),
              legend.position = "none",
              plot.margin = margin(0,0,0,8,"pt"),
              plot.title = element_text(size=5, margin = margin(0,0,0,0)),
              axis.text.y = element_text(size=5),
              axis.title.y = element_text(size=5))

    fig_five_b = plot_grid(tss_plot, tfiib_plot, ncol=1, align="vh", axis="trbl") %>%
        add_label("B")

    ggplot2::ggsave(svg_out, plot=fig_five_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_five_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_five_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_five_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     cluster_one = snakemake@input[["cluster_one"]],
     cluster_two = snakemake@input[["cluster_two"]],
     tss_diffexp = snakemake@input[["tss_diffexp"]],
     tfiib_diffbind = snakemake@input[["tfiib_diffbind"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])