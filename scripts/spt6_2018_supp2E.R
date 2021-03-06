
main = function(theme_spec, plot_functions, vam6_tfiib_nexus_path, ypt52_tfiib_nexus_path,
                vam6_tss_sense_path, ypt52_tss_sense_path, qpcr_data_path,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(plot_functions)
    library(broom)
    library(cowplot)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    vam6_tfiib_nexus_df = import(vam6_tfiib_nexus_path, sample_list=sample_list)
    vam6_tss_sense_df = import(vam6_tss_sense_path, sample_list=sample_list)
    vam6_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="VAM6", norm="pma1+")

    ypt52_tfiib_nexus_df = import(ypt52_tfiib_nexus_path, sample_list=sample_list)
    ypt52_tss_sense_df = import(ypt52_tss_sense_path, sample_list=sample_list)
    ypt52_qpcr_df = build_qpcr_df(qpcr_data_path, gene_id="YPT52", norm="pma1+")

    ypt52_qpcr_df %>%
        do(t.test(value ~ condition,
                  data = .,
                  alternative = "less") %>%
               tidy()) %>%
        print()

    vam6_tfiib_plot = plot_seq_data(qpcr_df = vam6_qpcr_df,
                                    seqdata_df = vam6_tfiib_nexus_df,
                                    title = "TFIIB ChIP-nexus protection",
                                    show_legend = FALSE)
    vam6_tss_sense_plot = plot_seq_data(qpcr_df = vam6_qpcr_df,
                                  seqdata_df = vam6_tss_sense_df,
                                  title = "sense TSS-seq signal",
                                  line_type="solid", show_amplicons=FALSE)
    vam6_qpcr_plot = plot_qpcr(qpcr_df = vam6_qpcr_df, seqdata_df = vam6_tfiib_nexus_df,
                               title = "TFIIB ChIP-qPCR")

    ypt52_tfiib_plot = plot_seq_data(qpcr_df = ypt52_qpcr_df,
                                    seqdata_df = ypt52_tfiib_nexus_df,
                                    title = "TFIIB ChIP-nexus protection",
                                    show_y_title = FALSE, show_legend=FALSE, show_title=FALSE)
    ypt52_tss_sense_plot = plot_seq_data(qpcr_df = ypt52_qpcr_df,
                                  seqdata_df = ypt52_tss_sense_df,
                                  title = "sense TSS-seq signal",
                                  show_y_title = FALSE,
                                  line_type = "solid",
                                  show_legend = FALSE, show_title=FALSE,
                                  show_amplicons=FALSE)
    ypt52_qpcr_plot = plot_qpcr(qpcr_df = ypt52_qpcr_df,
                               seqdata_df = ypt52_tfiib_nexus_df,
                               title = "TFIIB ChIP-qPCR",
                               show_y_title = FALSE,
                               show_legend = FALSE,
                               show_title=FALSE, xunits_tick=1)

    vam6_diagram = plot_gene_diagram(qpcr_df = vam6_qpcr_df,
                                     seqdata_df = vam6_tfiib_nexus_df,
                                     gene_id = "VAM6")
    ypt52_diagram = plot_gene_diagram(qpcr_df = ypt52_qpcr_df,
                                     seqdata_df = ypt52_tfiib_nexus_df,
                                     gene_id = "YPT52")

    supp_two_e = plot_grid(vam6_diagram, ypt52_diagram,
                          vam6_tss_sense_plot, ypt52_tss_sense_plot,
                          vam6_tfiib_plot, ypt52_tfiib_plot,
                          vam6_qpcr_plot, ypt52_qpcr_plot,
                          ncol=2,
                          rel_heights=c(0.41,1,1,1),
                          rel_widths=c(1,1),
                          align="vh", axis="trbl") %>%
        add_label("E")
    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    ggplot2::ggsave(svg_out, plot=supp_two_e, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=supp_two_e, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=supp_two_e, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_two_e, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     plot_functions= snakemake@input[["plot_functions"]],
     vam6_tfiib_nexus_path = snakemake@input[["vam6_tfiib_nexus_path"]],
     ypt52_tfiib_nexus_path = snakemake@input[["ypt52_tfiib_nexus_path"]],
     vam6_tss_sense_path = snakemake@input[["vam6_tss_sense_path"]],
     ypt52_tss_sense_path = snakemake@input[["ypt52_tss_sense_path"]],
     qpcr_data_path = snakemake@input[["qpcr_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

