
main = function(theme_spec, intra_diffexp_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(intra_diffexp_data) %>%
        count(orf_name)

    supp_one_d = ggplot(data = df, aes(x=n)) +
        geom_histogram(binwidth=1, center=0, fill="#114477", color="white", size=0.1) +
        xlab("intragenic TSSs per ORF") +
        theme_default +
        theme(axis.title.y = element_blank(),
              axis.title.x = element_text(margin = margin(t=2, unit="pt")))

    supp_one_d %<>% add_label("d")

    ggsave(svg_out, plot=supp_one_d, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one_d, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     intra_diffexp_data = snakemake@input[["intra_diffexp_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

