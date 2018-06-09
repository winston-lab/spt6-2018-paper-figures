
import = function(df, path, label_col_id, category){
    df = read_tsv(path) %>%
        distinct(chrom, start, end, peak_name, score, strand, .keep_all = TRUE) %>%
        select(chrom, start, end, label=label_col_id, score, strand, log2_foldchange, lfc_SE, stat,
               log10_pval, log10_padj, mean_expr, condition_expr, control_expr) %>%
        mutate(category = category) %>%
        bind_rows(df, .) %>%
        return()
}

main = function(theme_spec, in_genic, in_intra, in_anti, in_inter, alpha,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = tibble() %>%
        import(in_genic, label_col_id="genic_name", category="genic") %>%
        import(in_intra, label_col_id="orf_name", category="intragenic") %>%
        import(in_anti, label_col_id="transcript_name", category="antisense") %>%
        import(in_inter, label_col_id="peak_name", category="intergenic") %>%
        mutate(category = fct_inorder(category, ordered=TRUE),
               significance = if_else(log10_padj > -log10(alpha), TRUE, FALSE)) %>%
        mutate(direction = if_else(log2_foldchange >= 0, "upregulated", "downregulated"))

    summary_df = df %>% count(category, significance, direction) %>%
        group_by(category) %>%
        mutate(group_total = sum(n)) %>%
        ungroup() %>%
        spread(direction, n) %>%
        filter(significance) %>%
        mutate(ymax=cumsum(group_total),
               ymin=ymax-group_total,
               y=(ymax+ymin)/2) %>%
        rowid_to_column(var = "ymax_unscaled") %>%
        mutate(ymin_unscaled = lag(ymax_unscaled, default=as.integer(0)),
               y_unscaled = (ymin_unscaled+ymax_unscaled)/2)

    fig_one_c = ggplot(data = summary_df) +
        geom_segment(aes(x=if_else(category=="genic", upregulated, -downregulated),
                         xend=if_else(category=="genic", 3000, -4100),
                         # y=y+800, yend=y+800),
                         y=y_unscaled+0.15, yend=y_unscaled+0.15),
                     alpha=0.2, size=0.2) +
        geom_rect(aes(xmin=0, xmax=upregulated,
                      # ymax=ymax, ymin=ymin),
                      ymax=ymax_unscaled, ymin=ymin_unscaled),
                  # size=0.5, color="white", fill=ptol_pal()(2)[2], alpha=0.7) +
                  size=0.5, color="white", fill="#fdcdac", alpha=0.9) +
        geom_rect(aes(xmin=-downregulated, xmax=0,
                      # ymax=ymax, ymin=ymin),
                      ymax=ymax_unscaled, ymin=ymin_unscaled),
                  size=0.5, color="white", fill="#cbd5e8", alpha=0.9) +
        geom_text(aes(x=if_else(upregulated>1000, upregulated/2, upregulated+30),
                      hjust = if_else(upregulated>1000, 0.5, 0),
                      # y=y,
                      y=y_unscaled,
                      label=upregulated),
                  size=9/72*25.4) +
        geom_text(aes(x=if_else(downregulated>900, -downregulated/2, -(downregulated+30)),
                      hjust = if_else(downregulated>900, 0.5, 1),
                      # y=y,
                      y=y_unscaled,
                      label=downregulated),
                  size=9/72*25.4) +
        geom_text(aes(x=if_else(category=="genic", 3000, -4100),
                      hjust = if_else(category=="genic", 1, 0),
                      # y=y,
                      y=y_unscaled,
                      label = category),
                  size=9/72*25.4) +
        annotate(geom="label", x=max(summary_df[["upregulated"]])/2,
                 fill= "#fdcdac",
                 label.r = unit(0, "pt"),
                 label.size = NA,
                 # y=-500,
                 y=-0.3,
                 hjust=0.5, label="upregulated", size=7/72*25.4) +
        annotate(geom="label", x=max(summary_df[["downregulated"]])/-2,
                 # y=-500,
                 fill= "#cbd5e8",
                 label.r = unit(0, "pt"),
                 label.size = NA,
                 y=-0.3,
                 hjust=0.5, label="downregulated", size=7/72*25.4) +
        # scale_y_reverse(limits = c(max(summary_df[["ymax"]]), -2500),
        scale_y_reverse(limits = c(max(summary_df[["ymax_unscaled"]]), -.5),
                        expand = c(0,0))+
        theme_void() +
        theme(plot.margin = margin(l=2, unit="pt"))

    fig_one_c %<>% add_label("C")

    ggsave(svg_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     in_genic = snakemake@input[["in_genic"]],
     in_intra = snakemake@input[["in_intra"]],
     in_anti = snakemake@input[["in_anti"]],
     in_inter = snakemake@input[["in_inter"]],
     alpha = 0.1,
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])



    # df = read_tsv(diffexp_data) %>%
    #     filter(category %in% c("genic", "intragenic", "antisense", "intergenic")) #%>%
    #     mutate_at(vars(category, change), funs(fct_inorder(., ordered=TRUE))) %>%
    #     mutate(change = fct_recode(change,
    #                                "up" = "up",
    #                                "n.s." = "unchanged",
    #                                "down" = "down"),
    #            xmax = cumsum(n),
    #            xmin = xmax-n,
    #            xmax = xmax/sum(n),
    #            xmin = xmin/sum(n)) %>%
    #     group_by(category) %>%
    #     mutate(xmin = min(xmin),
    #            xmax = max(xmax),
    #            ymax = cumsum(n),
    #            ymin = ymax-n,
    #            ymax = ymax/sum(n),
    #            ymin = ymin/sum(n),
    #            x = (xmin+xmax)/2,
    #            y = (ymin+ymax)/2)
    #
    # cat_label_df = df %>%
    #     summarise(x=first(x), y=first(y))
    #
    # fig_one_e = ggplot() +
    #     geom_rect(data = df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=change),
    #               color="white", size=1, alpha=0.9) +
    #     geom_text(data = df, aes(x=x, y=y, label=n),
    #               size=7/72*25.4, fontface="plain",
    #               # label.padding = unit(0,"pt"),
    #               # label.r= unit(0, "pt"),
    #               # label.size= unit(0, "pt"),
    #               alpha=1) +
    #     geom_text(data = cat_label_df,
    #               aes(x=x, y=0, label=category),
    #               angle=30, vjust=1, hjust=1,
    #               size=7/72*25.4, fontface="plain") +
    #     scale_fill_ptol(guide=guide_legend(reverse=TRUE)) +
    #     scale_x_continuous(expand=c(0,0)) +
    #     scale_y_continuous(limits=c(-0.19, 1),
    #                        expand=c(0,0)) +
    #     # geom_hline(yintercept = 0.5) +
    #     ggtitle("TSS-seq differential expression") +
    #     theme_void() +
    #     theme(text = element_text(size=9, color="black", face="plain"),
    #           plot.title = element_text(size=9, color="black", face="plain",
    #                                     margin = margin(0,0,0,0,"pt")),
    #           legend.key.size = unit(14, "pt"),
    #           legend.justification = c(0.5, 0.65),
    #           legend.title = element_blank(),
    #           legend.text = element_text(size=7, color="black", face="plain", vjust=0.5,
    #                                      margin = margin(0,0,0,0,"pt")),
    #           legend.background = element_blank(),
    #           legend.margin = margin(0,0,0,0,"pt"),
    #           legend.box.margin = margin(0,0,0,0,"pt"),
    #           legend.box.spacing = unit(0, "pt"),
    #           plot.margin = margin(10,3,0,5,"pt"))
