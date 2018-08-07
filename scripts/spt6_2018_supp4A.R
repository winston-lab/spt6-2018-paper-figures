
main = function(theme_spec, scatterplot_script, mnase_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(scatterplot_script)

    supp_four_a = plot_scatter(data_path = mnase_data,
                              title = "MNase-seq dyad signal",
                              sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2"),
                              pcount = 1,
                              genome_binsize = "75 bp bins",
                              plot_binwidth = 0.03) %>%
        add_label("A")
    supp_four_a = supp_four_a +
        theme(plot.margin = margin(r=11/2, unit="pt"))

    ggsave(svg_out, plot=supp_four_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_four_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_four_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_four_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     scatterplot_script = snakemake@input[["scatterplot_script"]],
     mnase_data = snakemake@input[["mnase_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

