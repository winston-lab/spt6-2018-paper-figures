
main = function(theme_spec, diffexp_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = read_tsv(diffexp_data) %>%
        filter(category %in% c("genic", "intragenic", "antisense", "intergenic")) %>%
        mutate_at(vars(category, change), funs(fct_inorder(., ordered=TRUE))) %>%
        mutate(change = fct_recode(change,
                                   "up" = "up",
                                   "n.s." = "unchanged",
                                   "down" = "down"),
               xmax = cumsum(n),
               xmin = xmax-n,
               xmax = xmax/sum(n),
               xmin = xmin/sum(n)) %>%
        group_by(category) %>%
        mutate(xmin = min(xmin),
               xmax = max(xmax),
               ymax = cumsum(n),
               ymin = ymax-n,
               ymax = ymax/sum(n),
               ymin = ymin/sum(n),
               x = (xmin+xmax)/2,
               y = (ymin+ymax)/2)

    cat_label_df = df %>%
        summarise(x=first(x), y=first(y))

    fig_one_e = ggplot() +
        geom_rect(data = df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=change),
                  color="white", size=1, alpha=0.9) +
        geom_text(data = df, aes(x=x, y=y, label=n),
                  size=7/72*25.4, fontface="plain",
                  # label.padding = unit(0,"pt"),
                  # label.r= unit(0, "pt"),
                  # label.size= unit(0, "pt"),
                  alpha=1) +
        geom_text(data = cat_label_df,
                  aes(x=x, y=0, label=category),
                  angle=30, vjust=1, hjust=1,
                  size=7/72*25.4, fontface="plain") +
        scale_fill_ptol(guide=guide_legend(reverse=TRUE)) +
        scale_x_continuous(expand=c(0,0)) +
        scale_y_continuous(limits=c(-0.19, 1),
                           expand=c(0,0)) +
        # geom_hline(yintercept = 0.5) +
        ggtitle("TSS-seq differential expression") +
        theme_void() +
        theme(text = element_text(size=9, color="black", face="plain"),
              plot.title = element_text(size=9, color="black", face="plain",
                                        margin = margin(0,0,0,0,"pt")),
              legend.key.size = unit(14, "pt"),
              legend.justification = c(0.5, 0.65),
              legend.title = element_blank(),
              legend.text = element_text(size=7, color="black", face="plain", vjust=0.5,
                                         margin = margin(0,0,0,0,"pt")),
              legend.background = element_blank(),
              legend.margin = margin(0,0,0,0,"pt"),
              legend.box.margin = margin(0,0,0,0,"pt"),
              legend.box.spacing = unit(0, "pt"),
              plot.margin = margin(10,3,0,5,"pt"))

    fig_one_e %<>% add_label("e")

    ggsave(svg_out, plot=fig_one_e, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_e, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_e, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_e, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     diffexp_data = snakemake@input[["diffexp_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

