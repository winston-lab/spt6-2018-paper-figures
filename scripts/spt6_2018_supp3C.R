
main = function(theme_spec, scatterplot_script, data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(scatterplot_script)

    supp_three_c = plot_scatter(data_path = data_path,
                              title = "ChIP-nexus signal",
                              sample_list = c("YPD-RNAPII-1", "YPD-RNAPII-2", "YPD-Spt6-1", "YPD-Spt6-2"),
                              pcount = 0.1,
                              genome_binsize = "200 nt bins",
                              plot_binwidth = 0.07,
                              chipnexus= TRUE) %>%
        add_label("C")

    ggsave(svg_out, plot=supp_three_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_three_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_three_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_three_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     scatterplot_script = snakemake@input[["scatterplot_script"]],
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
