
main = function(theme_spec, plot_functions, avt2_tfiib_nexus_path, flo8_tfiib_nexus_path,
                avt2_tss_sense_path, flo8_tss_sense_path, qpcr_data_path,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(plot_functions)
    library(broom)
    library(cowplot)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    avt2_tfiib_nexus_df = import(avt2_tfiib_nexus_path, sample_list=sample_list)
    avt2_tss_sense_df = import(avt2_tss_sense_path, sample_list=sample_list)
    avt2_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="AVT2", norm="pma1+")

    avt2_qpcr_df %>%
        do(t.test(value ~ condition,
                  data = .,
                  alternative = "less") %>%
               tidy()) %>%
        print()

    flo8_tfiib_nexus_df = import(flo8_tfiib_nexus_path, sample_list=sample_list)
    flo8_tss_sense_df = import(flo8_tss_sense_path, sample_list=sample_list)
    flo8_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="FLO8", norm="pma1+")

    avt2_tfiib_plot = plot_seq_data(qpcr_df = avt2_qpcr_df,
                                    seqdata_df = avt2_tfiib_nexus_df,
                                    title = "TFIIB ChIP-nexus protection",
                                    show_y_title = FALSE,
                                    show_legend=FALSE,
                                    show_title=FALSE)
    avt2_tss_sense_plot = plot_seq_data(qpcr_df = avt2_qpcr_df,
                                  seqdata_df = avt2_tss_sense_df,
                                  title = "sense TSS-seq signal",
                                  line_type="solid",
                                  show_amplicons=FALSE,
                                  show_y_title = FALSE,
                                  show_legend = FALSE,
                                  show_title=FALSE)
    avt2_qpcr_plot = plot_qpcr(qpcr_df = avt2_qpcr_df, seqdata_df = avt2_tfiib_nexus_df,
                               show_y_title = FALSE,
                               show_legend = FALSE,
                               show_title=FALSE,
                               title = "TFIIB ChIP-qPCR", xunits_tick=2)

    flo8_tfiib_plot = plot_seq_data(qpcr_df = flo8_qpcr_df,
                                    seqdata_df = flo8_tfiib_nexus_df,
                                    title = "TFIIB ChIP-nexus protection",
                                    show_legend = FALSE)
    flo8_tss_sense_plot = plot_seq_data(qpcr_df = flo8_qpcr_df,
                                  seqdata_df = flo8_tss_sense_df,
                                  title = "sense TSS-seq signal",
                                  line_type = "solid",
                                  show_amplicons=FALSE)
    flo8_tss_sense_plot = flo8_tss_sense_plot +
        theme(legend.position = c(0.4, 0.75))
    flo8_qpcr_plot = plot_qpcr(qpcr_df = flo8_qpcr_df,
                               seqdata_df = flo8_tfiib_nexus_df,
                               title = "TFIIB ChIP-qPCR",
                               xunits_tick=2,
                               show_legend=FALSE)

    avt2_diagram = plot_gene_diagram(qpcr_df = avt2_qpcr_df,
                                     seqdata_df = avt2_tfiib_nexus_df,
                                     gene_id = "AVT2")
    flo8_diagram = plot_gene_diagram(qpcr_df = flo8_qpcr_df,
                                     seqdata_df = flo8_tfiib_nexus_df,
                                     gene_id = "FLO8")

    fig_two_c = plot_grid(flo8_diagram, avt2_diagram,
                          flo8_tss_sense_plot, avt2_tss_sense_plot,
                          flo8_tfiib_plot, avt2_tfiib_plot,
                          flo8_qpcr_plot, avt2_qpcr_plot,
                          ncol=2,
                          rel_heights=c(0.37,1,1,1),
                          rel_widths=c(1,1),
                          align="vh", axis="trbl") %>%
        add_label("C")
    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    ggplot2::ggsave(svg_out, plot=fig_two_c, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_two_c, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_two_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     plot_functions= snakemake@input[["plot_functions"]],
     avt2_tfiib_nexus_path = snakemake@input[["avt2_tfiib_nexus_path"]],
     flo8_tfiib_nexus_path = snakemake@input[["flo8_tfiib_nexus_path"]],
     avt2_tss_sense_path = snakemake@input[["avt2_tss_sense_path"]],
     flo8_tss_sense_path = snakemake@input[["flo8_tss_sense_path"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

