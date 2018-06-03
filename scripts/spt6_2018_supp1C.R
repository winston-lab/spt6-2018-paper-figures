
main = function(theme_spec, data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(data_path,
                  col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand', 'assay')) %>%
        filter(assay %in% c("TSS-seq", "RNA-seq")) %>%
        select(-c(chrom, start, end, strand)) %>%
        spread(assay, score) %>%
        magrittr::set_colnames(c("gene", "rna", "tss"))

    cor = df %>% select(-gene) %>%
        na_if(0) %>%
        log10() %>%
        cor(method="pearson", use="pairwise.complete.obs") %>%
        as_tibble() %>%
        pull(tss) %>%
        extract(1) %>%
        signif(2)

    supp_one_c = ggplot(data = df, aes(x=tss+1, y=rna+1)) +
        stat_bin_hex(geom="point", aes(color=..count..),
                     binwidth=c(.05,.05), alpha=0.8, size=0.1) +
        annotate(geom="label", x=1e4, y=1e1, label= paste0("R=", cor),
                 size=7/72*25.4, label.r=unit(0,"pt"), label.padding=unit(2,"pt"),
                 label.size=NA) +
        scale_color_viridis(option="inferno", guide=FALSE) +
        scale_fill_viridis(option="inferno", guide=FALSE) +
        scale_x_log10(name = "TSS-seq (RPM)") +
        scale_y_log10(name = "RNA-seq\n(RPKM)") +
        ggtitle(expression(WT*"," ~ 37*degree*C)) +
        theme_default +
        theme(axis.title.x = element_text(margin = margin(t=3, unit="pt")),
              axis.title.y = element_text(angle=0, hjust=1, vjust=0.5),
              axis.text = element_text(size=5))

    supp_one_c %<>% add_label("C")

    ggsave(svg_out, plot=supp_one_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

