
main = function(theme_spec,
                all_motif_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(stringr)
    library(ggrepel)

    all_df = read_tsv(all_motif_path) %>%
        mutate(label = if_else(is.na(motif_alt_id), motif_id, motif_alt_id)) %>%
        separate(label, into=c("label", "ext"), sep = "\\.", fill="right") %>%
        select(-ext) %>%
        mutate(label = label %>%
                   str_remove("p$") %>%
                   str_to_title(),
               label = if_else(str_detect(label, "^Y[a-p][rl]\\d+[wc]$"),
                               str_to_upper(label),
                               label))

    volcano_plot = ggplot() +
        geom_vline(xintercept = 0, color="grey65", size=0.5) +
        geom_point(data = all_df %>% filter(fdr>=0.01),
                   aes(x=log2_odds_ratio, y=-log10(fdr)),
                   size=0.4, alpha=0.4, color="grey40") +
        geom_hline(yintercept = -log10(0.01),
                   linetype="dashed") +
        geom_label_repel(data = all_df %>% filter(fdr<0.01),
                  aes(x=log2_odds_ratio, y=-log10(fdr), label=label,
                      fill=if_else(log2_odds_ratio<0, "depleted", "enriched")),
                  size=5/72*25.4,
                  box.padding = unit(0, "pt"), label.r = unit(0.5, "pt"),
                  label.size=NA, label.padding = unit(0.8, "pt"),
                  ylim = c(-log10(0.015), NA), force=0.5,
                  segment.size = 0.2, segment.alpha=0.5) +
        annotate(geom="label", x=1, y=9.7, label="enriched", size=7/72*25.4,
                 fill="#fbb4ae", label.size=NA) +
        annotate(geom="label", x=-1, y=9.7, label="depleted", size=7/72*25.4,
                 fill="#b3cde3", label.size=NA) +
        scale_y_continuous(expand = c(0,0),
                           breaks = scales::pretty_breaks(n=3),
                           name = expression(-log[10]("FDR"))) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=5),
                           name = expression(log[2]("odds ratio vs. random"))) +
        scale_fill_brewer(palette = "Pastel1", direction=-1, guide=FALSE) +
        ggtitle(bquote("motifs at" ~ italic("spt6-1004") ~ "intragenic TSSs")) +
        theme_default +
        theme(panel.grid = element_blank(),
              panel.border = element_blank(),
              axis.line = element_line(color="grey65", size=0.2),
              axis.title.y = element_text(margin=margin(r=0, unit="pt")),
              plot.margin = margin(0, 0, -2, 11/2, "pt"))

    fig_five_e = volcano_plot %>%
        add_label("E")

    ggsave(svg_out, plot=fig_five_e, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_five_e, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_five_e, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_five_e, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     all_motif_path = snakemake@input[["all_motif_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

