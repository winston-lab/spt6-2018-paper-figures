
main = function(theme_spec, plot_functions,
                pma1_tfiib_nexus_path,
                # pma1_tss_sense_path,
                pma1_mnase_path,
                hsp82_tfiib_nexus_path,
                # hsp82_tss_sense_path,
                hsp82_mnase_path,
                qpcr_data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(plot_functions)
    library(cowplot)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    pma1_tfiib_nexus_df = import(pma1_tfiib_nexus_path, sample_list=sample_list)
    # pma1_tss_sense_df = import(pma1_tss_sense_path, sample_list=sample_list)
    pma1_mnase_df = import(pma1_mnase_path, sample_list=c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2"))
    pma1_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="PMA1", norm="pma1+")

    hsp82_tfiib_nexus_df = import(hsp82_tfiib_nexus_path, sample_list=sample_list)
    # hsp82_tss_sense_df = import(hsp82_tss_sense_path, sample_list=sample_list)
    hsp82_mnase_df = import(hsp82_mnase_path, sample_list=c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2"))
    hsp82_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="HSP82", norm="pma1+")

    # pma1_tss_sense_plot = plot_seq_data(qpcr_df = pma1_qpcr_df,
    #                               seqdata_df = pma1_tss_sense_df,
    #                               title = "sense TSS-seq signal",
    #                               line_type="solid", show_amplicons=FALSE)
    pma1_tfiib_plot = plot_seq_data(qpcr_df = pma1_qpcr_df,
                                    seqdata_df = pma1_tfiib_nexus_df,
                                    title = "TFIIB ChIP-nexus protection",
                                    show_legend=FALSE)
    pma1_mnase_plot = plot_seq_data(qpcr_df = pma1_qpcr_df,
                                    seqdata_df = pma1_mnase_df,
                                    title = "smoothed MNase-seq dyad signal",
                                    show_amplicons=FALSE)
    pma1_qpcr_plot = plot_qpcr(qpcr_df = pma1_qpcr_df, seqdata_df = pma1_tfiib_nexus_df,
                               title = "TFIIB ChIP-qPCR")
    pma1_diagram = plot_gene_diagram(qpcr_df = pma1_qpcr_df,
                                     seqdata_df = pma1_tfiib_nexus_df,
                                     gene_id = "PMA1")

    # hsp82_tss_sense_plot = plot_seq_data(qpcr_df = hsp82_qpcr_df,
    #                               seqdata_df = hsp82_tss_sense_df,
    #                               title = "sense TSS-seq signal",
    #                               line_type="solid", show_amplicons=FALSE,
    #                               show_legend=FALSE, show_title=FALSE, show_y_title=FALSE)
    hsp82_tfiib_plot = plot_seq_data(qpcr_df = hsp82_qpcr_df,
                                    seqdata_df = hsp82_tfiib_nexus_df,
                                    title = "TFIIB ChIP-nexus protection",
                                    show_legend = FALSE, show_title=FALSE,
                                    show_y_title=FALSE)
    hsp82_mnase_plot = plot_seq_data(qpcr_df = hsp82_qpcr_df,
                                    seqdata_df = hsp82_mnase_df,
                                    title = "smoothed MNase-seq dyad signal",
                                    show_legend = FALSE, show_amplicons=FALSE, show_y_title=FALSE,
                                    show_title=FALSE)
    hsp82_qpcr_plot = plot_qpcr(qpcr_df = hsp82_qpcr_df, seqdata_df = hsp82_tfiib_nexus_df,
                               title = "TFIIB ChIP-qPCR", show_title=FALSE, show_y_title=FALSE,
                               show_legend=FALSE, xunits_tick=2)
    hsp82_diagram = plot_gene_diagram(qpcr_df = hsp82_qpcr_df,
                                     seqdata_df = hsp82_tfiib_nexus_df,
                                     gene_id = "HSP82")

    fig_six_a = plot_grid(pma1_diagram, hsp82_diagram,
                          pma1_mnase_plot, hsp82_mnase_plot,
                          # pma1_tss_sense_plot, hsp82_tss_sense_plot,
                          pma1_tfiib_plot, hsp82_tfiib_plot,
                          pma1_qpcr_plot, hsp82_qpcr_plot,
                          ncol=2,
                          rel_heights = c(0.4,1,1,1,1),
                          rel_widths = c(1,1),
                          align="vh", axis="trbl") %>%
        add_label("A")

    ggplot2::ggsave(svg_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_six_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     plot_functions = snakemake@input[["plot_functions"]],
     pma1_tfiib_nexus_path = snakemake@input[["pma1_tfiib_nexus"]],
     # pma1_tss_sense_path = snakemake@input[["pma1_tss_sense"]],
     pma1_mnase_path = snakemake@input[["pma1_mnase"]],
     hsp82_tfiib_nexus_path = snakemake@input[["hsp82_tfiib_nexus"]],
     # hsp82_tss_sense_path = snakemake@input[["hsp82_tss_sense"]],
     hsp82_mnase_path = snakemake@input[["hsp82_mnase"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

