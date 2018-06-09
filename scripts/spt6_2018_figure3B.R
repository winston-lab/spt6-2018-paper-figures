
main = function(theme_spec, netseq_results, annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(netseq_results) %>%
        left_join(read_tsv(annotation,
                           col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')),
                  by = c('chrom', 'start', 'end', 'transcript_id' = 'name')) %>%
        drop_na()

    fig_three_b = ggplot(data = df, aes(x=score+0.01, y=log2FoldChange)) +
        geom_hline(yintercept = 0, size=0.4, color="grey65") +
        stat_bin_hex(geom="point", aes(color=(..count..)),
                     binwidth = c(0.04, 0.04), size=0.1, alpha=0.8, fill=NA) +
        scale_color_viridis(option="inferno", guide=FALSE) +
        scale_x_log10("wild-type Spt6 levels (ChIP-nexus RPKM)") +
        ylab(expression(atop("sense NET-seq", log[2] ~ frac(italic("spt6-1004"), "WT")))) +
        theme_default +
        theme(axis.title.y = element_text(angle=0, hjust=1, vjust=0.5, size=9),
              axis.title.x = element_text(margin = margin(t=3, unit="pt"), size=9))

    fig_three_b %<>% add_label("B")

    ggsave(svg_out, plot=fig_three_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_three_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_three_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_three_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     netseq_results = snakemake@input[["netseq_results"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

