
import = function(path, normalize=FALSE){
    df = read_tsv(path,
                  col_names=c('group', 'sample', 'annotation',
                              'assay', 'index', 'position', 'signal')) %>%
        group_by(annotation) %>%
        mutate(anno_labeled = paste0(annotation, " (", n_distinct(index), " TSSs)"))
    if (normalize){
        df %<>%
            group_by(group, sample, annotation, anno_labeled, index) %>%
            mutate(signal = scales::rescale(signal))
    }
    df %>%
        group_by(group, annotation, anno_labeled, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels=c("spt6+", "spt6-1004-37C"),
                               labels=c("WT", "spt6-1004-37C"))) %>%
        return()
}

metagene = function(df, assay, ylabel="", top=FALSE, bottom=FALSE){
    plot = ggplot() +
        geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(data = df,
                    aes(x=position, ymin=low, ymax=high, fill=group),
                    alpha=if(bottom){0.15} else {0.2}, linetype='blank') +
        geom_line(data = df,
                  aes(x=position, y=mid, color=group),
                  alpha=0.8) +
        geom_label(data = tibble(label=assay, x=-0.495, y=max(df[["high"]])*1.02, anno_labeled="intragenic cluster 1 (2147 TSSs)"),
                  aes(x=x, y=y, label=label),
                  hjust=0, vjust=1, size=9/72*25.4,
                  label.size=NA, label.padding = unit(1, "pt"), label.r=unit(0,"pt")) +
        facet_grid(.~anno_labeled) +
        scale_x_continuous(expand = c(0,0),
                           breaks = c(-0.4, 0, 0.4),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==0.4 ~ paste(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=3),
                           # expand = c(0.05, 0),
                           name = ylabel) +
        theme_default +
        theme(legend.justification = c(0, 1),
              legend.background = element_blank(),
              legend.position = c(0.005, 0.90),
              legend.key.width= unit(14, "pt"),
              legend.key.height = unit(10, "pt"),
              axis.title.x = element_blank(),
              axis.title.y = element_text(hjust=0.5),
              panel.spacing.x = unit(10, "pt"),
              panel.grid = element_blank(),
              plot.margin = margin(0,11/2,0,0,"pt"))
    if (assay != "GC%"){
        plot = plot +
            scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
            scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004"))))
    } else {
        plot = plot +
            scale_fill_manual(values="grey30") +
            scale_color_manual(values="grey30")
    }
    if (! bottom){
        plot = plot +
            theme(axis.text.x = element_blank(),
                  axis.ticks.x = element_blank())
    }
    if (top){
        plot = plot +
            theme(strip.text = element_text(size=7, color="black",
                                            margin = margin(0,0,0,0)))
    } else {
        plot = plot +
            theme(legend.position = "none")
    }
    return(plot)
}

main = function(theme_spec,
                annotation,
                mnase_data,
                gc_data,
                # rnapii_data, spt6_data,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(cowplot)

    mnase_df = import(mnase_data)
    # rnapii_df = import(rnapii_data, normalize=TRUE)
    # spt6_df = import(spt6_data, normalize=TRUE)
    gc_df = import(gc_data) %>%
        filter(group=="WT")

    mnase_plot = metagene(mnase_df, assay="MNase-seq", ylabel="normalized dyad counts", top=TRUE)
    gc_plot = metagene(gc_df, ylabel="% (21bp)", assay="GC%", bottom=TRUE)
    # spt6_plot = metagene(spt6_df, ylabel="relative levels", assay="Spt6 ChIP-nexus")
    # rnapii_plot = metagene(rnapii_df, ylabel="relative levels", assay="RNAPII ChIP-nexus", bottom=TRUE)

    fig_five_a = plot_grid(mnase_plot, gc_plot,
                           # spt6_plot, rnapii_plot,
                           ncol=1,
                     align="v", axis="lr", rel_heights = c(1, 0.55, 0.55, 0.65)) %>%
        add_label("A")

    # anno = read_tsv(annotation,
    #                 col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
    #     rowid_to_column(var="index")

    ggplot2::ggsave(svg_out, plot=fig_five_a, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_five_a, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_five_a, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_five_a, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     annotation = snakemake@input[["annotation"]],
     mnase_data = snakemake@input[["mnase_data"]],
     # rnapii_data = snakemake@input[["rnapii_data"]],
     # spt6_data = snakemake@input[["spt6_data"]],
     gc_data = snakemake@input[["gc_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
