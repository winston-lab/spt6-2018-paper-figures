
main = function(theme_spec, plot_functions,
                vam6_mnase_path, qpcr_data_path,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(plot_functions)
    library(cowplot)
    sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")

    vam6_mnase_df = import(vam6_mnase_path, sample_list=sample_list)
    vam6_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="VAM6", norm="pma1+")
    vam6_mnase_plot = plot_seq_data(qpcr_df = vam6_qpcr_df,
                                    seqdata_df = vam6_mnase_df,
                                    title = "smoothed MNase-seq dyad signal") +
        theme(axis.text.x = element_text(size=7,
                                         color="black",
                                         margin=margin(1,0,0,0,"pt")))
    vam6_mnase_plot = vam6_mnase_plot +
        theme(legend.position = c(0.75, 0.75))
    vam6_qpcr_plot = plot_qpcr(qpcr_df = vam6_qpcr_df, seqdata_df = vam6_mnase_df,
                               title = "histone H3 ChIP-qPCR")
    vam6_qpcr_plot = vam6_qpcr_plot +
        theme(legend.position = c(0.75, 0.75))
    vam6_diagram = plot_gene_diagram(qpcr_df = vam6_qpcr_df,
                                     seqdata_df = vam6_mnase_df,
                                     gene_id = "VAM6")
    fig_four_d = plot_grid(vam6_diagram, vam6_diagram, vam6_mnase_plot, vam6_qpcr_plot,
                           ncol=2, align="vh", axis="trbl", rel_heights = c(0.37,1)) %>%
        add_label("D")

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    ggplot2::ggsave(svg_out, plot=fig_four_d, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_four_d, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_four_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_four_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     plot_functions= snakemake@input[["plot_functions"]],
     vam6_mnase_path = snakemake@input[["vam6_mnase_path"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
