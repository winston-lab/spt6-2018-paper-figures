
main = function(theme_spec, scatterplot_script, tfiib_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(scatterplot_script)

    supp_two_a = plot_scatter(data_path = tfiib_data,
                              title = "TFIIB ChIP-nexus signal",
                              sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2"),
                              pcount = 0.1,
                              genome_binsize = "10nt bins",
                              plot_binwidth = 0.07) %>%
        add_label("a")

    ggsave(svg_out, plot=supp_two_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_two_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_two_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_two_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     scatterplot_script = snakemake@input[["scatterplot_script"]],
     tfiib_data = snakemake@input[["tfiib_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
