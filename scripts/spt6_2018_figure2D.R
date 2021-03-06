
import = function(df, path, category){
    df = read_tsv(path) %>%
        mutate(category=category) %>%
        bind_rows(df, .) %>%
        return()
}

main = function(theme_spec, genic, intragenic, antisense,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = tibble() %>%
        import(genic, 'genic') %>%
        import(intragenic, 'intragenic') %>%
        import(antisense, 'antisense') %>%
        mutate(category=fct_inorder(category, ordered=TRUE)) %>%
        filter(! is.na(tss_lfc) & ! is.na(tfiib_lfc))
    count_df = df %>% count(category)

    fig_two_d = ggplot(data = df) +
        geom_hline(yintercept = 0, color="grey65") +
        geom_vline(xintercept = 0, color="grey65") +
        geom_abline(intercept = 0, slope=1, color="grey65") +
        stat_bin_hex(geom="point",
                     aes(x=tss_lfc, y=tfiib_lfc, color=(..count..)),
                     binwidth=c(0.13, 0.13), alpha=0.5, size=0.1, fill=NA) +
        geom_label(data = count_df,
                  aes(label=paste0("n=",n)),
                  x=-6, y=5, hjust=0, size=7/72*25.4,
                  label.padding = unit(2, "pt"),
                  label.r = unit(0, "pt"),
                  label.size = NA) +
        facet_wrap(~category, ncol=1) +
        scale_color_viridis(guide=FALSE, option="inferno") +
        scale_y_continuous(limits = c(-4.5, 6),
                           name = expression("TFIIB ChIP-nexus" ~ log[2] ~ textstyle(frac(italic("spt6-1004"), "WT")))) +
                           # name = expression("TFIIB ChIP-nexus" ~ log[2] ~ displaystyle(frac(italic("spt6-1004"), "WT")))) +
        scale_x_continuous(limits = c(-6, 8),
                           name = expression("TSS-seq" ~ log[2] ~ textstyle(frac(italic("spt6-1004"), "WT")))) +
                           # name = expression("TSS-seq" ~ log[2] ~ displaystyle(frac(italic("spt6-1004"), "WT")))) +
        theme_default +
        theme(strip.text = element_text(size=9, color="black", margin=margin(0,0,-10,0,"pt"),
                                        hjust=0, vjust=1),
              axis.title.x = element_text(size=8),
              axis.title.y = element_text(size=8, margin = margin(r=-5, unit="pt")),
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank(),
              panel.spacing.y = unit(0, "pt"),
              plot.margin=margin(0,0,-5,0,"pt"))

    fig_two_d %<>% add_label("D")

    ggsave(svg_out, plot=fig_two_d, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_two_d, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_two_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     genic = snakemake@input[["genic"]],
     intragenic = snakemake@input[["intragenic"]],
     antisense = snakemake@input[["antisense"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

