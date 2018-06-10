
main = function(theme_spec,
                go_results,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(go_results) %>%
        rename(pval=over_represented_pvalue) %>%
        filter(pval < 0.1) %>%
        arrange(desc(pval)) %>%
        mutate(term = fct_inorder(term, ordered=TRUE))

    fig_six_c = ggplot(data = df,
           aes(y=-log10(pval), x=term, fill=ontology)) +
        geom_hline(yintercept = 1, linetype="dashed") +
        geom_col(color="black", size=0.3) +
        coord_flip() +
        scale_fill_manual(values = ptol_pal()(4),
                          labels = c("biological process", "cellular compartment", "molecular function")) +
        scale_y_continuous(limits = c(0, 1.05*(-log10(min(df[["pval"]])))),
                           expand = c(0,0)) +
        ylab(expression(-log[10] ~ "adj. p-value")) +
        ggtitle("enriched GO terms",
                subtitle = expression(italic("spt6-1004") ~ "upregulated genic TSSs")) +
        theme_default +
        theme(axis.title.y = element_blank(),
              plot.title = element_text(margin=margin(0,0,3,0,"pt")),
              plot.subtitle = element_text(margin = margin(0,0,0,0,"pt")),
              legend.position = c(0.95, 0.05),
              legend.justification = c(1, 0),
              legend.key.size = unit(8, "pt"),
              legend.text = element_text(size=5),
              panel.border = element_blank(),
              panel.grid.major.y = element_blank(),
              plot.margin = margin(t=0, b=0, unit="pt"))

    fig_six_c %<>% add_label("C")

    ggsave(svg_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     go_results = snakemake@input[["go_results"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
