
main = function(theme_spec, fimo_results, tss_results,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(broom)

    motif_df = read_tsv(fimo_results) %>%
        mutate(match = if_else(motif_start==-1, FALSE, TRUE)) %>%
        separate_rows(region_id, sep = ",") %>%
        distinct(region_id, .keep_all=TRUE) %>%
        select(region_id, match)

    df = read_tsv(tss_results)  %>%
        distinct(peak_name, .keep_all = TRUE) %>%
        left_join(motif_df, by=c("peak_name"="region_id"))

    mwu_result = wilcox.test(condition_expr ~ match,
                             data = df,
                             alternative = "two.sided", conf.int=TRUE) %>%
        tidy()

    plot = ggplot(data = df, aes(x=match, y=condition_expr)) +
        geom_violin(aes(fill=match), bw=.05) +
        geom_boxplot(notch=TRUE, width=0.3, outlier.size=0) +
        scale_x_discrete(name=NULL,
                         labels = c("no TATA", "TATA")) +
        scale_y_log10(name="normalized counts") +
        scale_fill_tableau(guide=FALSE) +
        ggtitle(expression(intragenic ~ "TSS" ~ expression ~ level ~ "in" ~ italic("spt6-1004"))) +
        theme_default

    summary_df = df %>%
        group_by(match) %>%
        summarise(median = median(condition_expr),
                  pct_25 = quantile(condition_expr, 0.25),
                  pct_75 = quantile(condition_expr, 0.75))

    plot %<>% add_label("D")
    print(mwu_result)
    print(summary_df)

    ggsave(svg_out, plot=plot, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=plot, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=plot, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(plot, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     fimo_results= snakemake@input[["fimo_results"]],
     tss_results= snakemake@input[["tss_results"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
