
main = function(theme_spec, heatmap_scripts,
                sense_tss_data, antisense_tss_data, annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    source(heatmap_scripts)

    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")
    cps_dist = 0.3
    max_length = 3
    add_ylabel = TRUE
    cutoff_pct = 0.95

    sense_heatmap = plot_heatmap(data_path = sense_tss_data,
                                 sample_list = sample_list,
                                 anno_path = annotation,
                                 cps_dist = cps_dist,
                                 max_length= max_length,
                                 cutoff_pct= cutoff_pct,
                                 add_ylabel= TRUE,
                                 y_label="nonoverlapping coding genes",
                                 colorbar_title="sense TSS-seq signal")

    anti_heatmap = plot_heatmap(data_path = antisense_tss_data,
                                sample_list = sample_list,
                                anno_path = annotation,
                                cps_dist = cps_dist,
                                max_length= max_length,
                                cutoff_pct= cutoff_pct,
                                add_ylabel=FALSE,
                                colorbar_title="antisense TSS-seq signal")
    fig_one_a = arrangeGrob(sense_heatmap, anti_heatmap, nrow=1) %>%
        add_label("A")

    ggsave(svg_out, plot=fig_one_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     heatmap_scripts = snakemake@input[["heatmap_scripts"]],
     sense_tss_data = snakemake@input[["sense_tss_data"]],
     antisense_tss_data = snakemake@input[["antisense_tss_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

