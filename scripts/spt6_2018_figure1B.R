
main = function(theme_spec, tss_seq_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(tss_seq_data,
                  col_names = c('group', 'sample', 'annotation', 'index', 'position', 'signal')) %>%
        filter(group == "WT-37C") %>%
        group_by(group, annotation, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75))

    fig_one_b = ggplot(data = df,
                       aes(x=position, y=mid, ymin=low, ymax=high)) +
        geom_vline(xintercept = 0, size=0.2, color="grey65") +
        geom_vline(xintercept = 2, size=0.2, color="grey65") +
        geom_ribbon(size=0, alpha=0.4,
                    fill=wildtype_color) +
        geom_line(color=wildtype_color) +
        scale_x_continuous(labels = function(x){case_when(x==0 ~ "TSS",
                                                          x==2 ~ "CPS",
                                                          TRUE ~ "")},
                           expand = c(0,0)) +
        scale_y_continuous(name = "normalized counts") +
        ggtitle("sense TSS-seq signal") +
        theme_default +
        theme(axis.title.x = element_blank())

    ggsave(svg_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_b, width=fig_width, height=fig_height, units="cm")
    save(fig_one_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     tss_seq_data = snakemake@input[["tss_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

