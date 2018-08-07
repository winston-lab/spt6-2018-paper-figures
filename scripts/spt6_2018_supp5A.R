
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
                  size=6/72*25.4,
                  min.segment.length = unit(2, "cm"),
                  box.padding = unit(0, "pt"), label.r = unit(0.5, "pt"),
                  label.size=NA, label.padding = unit(0.4, "pt"),
                  ylim = c(-log10(0.05), NA),
                  force=0.8,
                  segment.size = 0.2, segment.alpha=0.2) +
        annotate(geom="label", x=1, y=110, label="enriched", size=9/72*25.4,
                 fill="#FFCEC8", label.size=NA) +
        annotate(geom="label", x=-1, y=110, label="depleted", size=9/72*25.4,
                 fill="#CDE7FD", label.size=NA) +
        scale_y_continuous(expand = c(0,0),
                           breaks = scales::pretty_breaks(n=3),
                           name = expression(-log[10]("FDR"))) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=5),
                           name = expression(log[2]("odds ratio vs. random"))) +
        # scale_fill_brewer(palette = "Pastel1", direction=-1, guide=FALSE) +
        scale_fill_manual(values = c("#CDE7FD","#FFCEC8"), guide=FALSE) +
        ggtitle("motifs at genic TSSs") +
        theme_default +
        theme(panel.grid = element_blank(),
              panel.border = element_blank(),
              axis.line = element_line(color="grey65", size=0.2),
              axis.title.y = element_text(margin=margin(r=0, unit="pt")),
              plot.margin = margin(0, 0, 0, 0, "pt"))

    supp_five_a = volcano_plot %>%
        add_label("A")

    ggsave(svg_out, plot=supp_five_a, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_five_a, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_five_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_five_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     all_motif_path = snakemake@input[["all_motif_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

