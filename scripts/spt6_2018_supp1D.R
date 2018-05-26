
main = function(theme_spec, intra_diffexp_data, orf_anno,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(orf_anno,
             col_names = c('chrom', 'start', 'end', 'orf_name', 'score', 'strand')) %>%
        select(orf_name) %>%
        left_join(intra_diffexp_data %>% read_tsv() %>% count(orf_name),
                  by="orf_name") %>%
        mutate(n = if_else(is.na(n), as.integer(0), n))

    supp_one_d = ggplot(data = df, aes(x=n)) +
        geom_histogram(binwidth=1, center=0, fill="#114477", color="white", size=0.1) +
        stat_bin(geom="text",
                 aes(y=..count..+20, label=..count..),
                 binwidth=1, center=0, size=5/72*25.4, hjust=0) +
        scale_x_continuous(limits = c(NA, max(df[["n"]])),
                           expand = c(0,0.3),
                           breaks = scales::pretty_breaks(n=3),
                           name = "# TSSs") +
        scale_y_continuous(limits = c(0, 3620),
                           breaks = scales::pretty_breaks(n=2),
                           expand=c(0,0)) +
        coord_flip() +
        ggtitle("# intragenic TSSs per ORF") +
        theme_default +
        theme(axis.title.x = element_blank(),
              plot.title = element_text(size=7, margin=margin(0,0,0,0)),
              axis.title.y = element_text(margin = margin(r=2, unit="pt")),
              panel.border = element_blank(),
              panel.grid.major.y = element_blank(),
              panel.grid.minor.y = element_blank(),
              axis.line.y = element_line(color="grey65", size=0.1))

    supp_one_d %<>% add_label("D")

    ggsave(svg_out, plot=supp_one_d, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one_d, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     intra_diffexp_data = snakemake@input[["intra_diffexp_data"]],
     orf_anno = snakemake@input[["orf_anno"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
