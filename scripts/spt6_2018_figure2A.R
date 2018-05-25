
main = function(theme_spec, heatmap_scripts,
                tfiib_data, annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(heatmap_scripts)

    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    anno = read_tsv(annotation,
                    col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
        rowid_to_column(var="index") %>%
        arrange(desc(end-start)) %>%
        rowid_to_column(var="sorted_index") %>%
        select(index, sorted_index)

    df = import(tfiib_data, sample_list=sample_list) %>% left_join(anno, by="index")

    fig_two_a = plot_heatmap(df=df, max_length=3, add_ylabel=TRUE, cutoff_pct=0.90,
                             y_label = "coding genes", colorbar_title="TFIIB ChIP-nexus protection") %>%
        add_label("A")

    ggsave(svg_out, plot=fig_two_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_two_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_two_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     heatmap_scripts = snakemake@input[["heatmap_scripts"]],
     tfiib_data = snakemake@input[["tfiib_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

