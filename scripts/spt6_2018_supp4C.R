
main = function(theme_spec, plot_functions,
                pma1_mnase_path,
                hsp82_mnase_path,
                qpcr_data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(plot_functions)
    library(cowplot)

    pma1_mnase_df = import(pma1_mnase_path, sample_list=c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2"))
    pma1_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="PMA1", norm="pma1+")

    hsp82_mnase_df = import(hsp82_mnase_path, sample_list=c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2"))
    hsp82_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="HSP82", norm="pma1+")

    pma1_mnase_plot = plot_seq_data(qpcr_df = pma1_qpcr_df,
                                    seqdata_df = pma1_mnase_df,
                                    title = "smoothed MNase-seq dyad signal")
    pma1_qpcr_plot = plot_qpcr(qpcr_df = pma1_qpcr_df, seqdata_df = pma1_mnase_df,
                               title = "histone H3 ChIP-qPCR")
    pma1_diagram = plot_gene_diagram(qpcr_df = pma1_qpcr_df,
                                     seqdata_df = pma1_mnase_df,
                                     gene_id = "PMA1")

    hsp82_mnase_plot = plot_seq_data(qpcr_df = hsp82_qpcr_df,
                                    seqdata_df = hsp82_mnase_df,
                                    title = "smoothed MNase-seq dyad signal",
                                    show_legend = FALSE, show_y_title=FALSE,
                                    show_title=FALSE)
    hsp82_qpcr_plot = plot_qpcr(qpcr_df = hsp82_qpcr_df, seqdata_df = hsp82_mnase_df,
                               title = "histone H3 ChIP-qPCR",
                               show_title=FALSE, show_y_title=FALSE,
                               show_legend=FALSE, xunits_tick=2)
    hsp82_diagram = plot_gene_diagram(qpcr_df = hsp82_qpcr_df,
                                     seqdata_df = hsp82_mnase_df,
                                     gene_id = "HSP82")

    supp_four_c = plot_grid(pma1_diagram, hsp82_diagram,
                          pma1_mnase_plot, hsp82_mnase_plot,
                          pma1_qpcr_plot, hsp82_qpcr_plot,
                          ncol=2,
                          rel_heights = c(0.4,1,1),
                          rel_widths = c(1,1),
                          align="vh", axis="trbl") %>%
        add_label("C")

    ggplot2::ggsave(svg_out, plot=supp_four_c, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=supp_four_c, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=supp_four_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_four_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     plot_functions = snakemake@input[["plot_functions"]],
     pma1_mnase_path = snakemake@input[["pma1_mnase"]],
     hsp82_mnase_path = snakemake@input[["hsp82_mnase"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

