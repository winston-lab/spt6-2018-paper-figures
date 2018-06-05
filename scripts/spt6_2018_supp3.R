library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(three_a, three_b, three_c, fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,NA,NA,NA,NA,NA,NA),
                   c(2,2,2,2,2,2,NA,NA,NA,NA,NA,NA),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4))

    load(three_a)
    load(three_b)
    load(three_c)
    legends = c("Figure S3. Spt6 alters the location and levels of the active",
                "RNAPII.",
                "(A)",
                "Comparison of library-sized normalized NET-seq signal in",
                "wild-type and spt6-1004 from cells cultured at 30C and 37C.",
                "Panels on the bottom left are scatterplots of the NET-seq",
                "signal in non-overlapping 100 nt bins with signal in at least",
                "one sample, panels on the diagonal are kernel density",
                "estimates of the same signal within each sample, and panels",
                "on the top right are Pearson correlations of log10(signal),",
                "comparing pairwise complete observations.",
                "(B)",
                "Heatmaps of fold-change in sense and antisense NET-seq signal",
                "between spt6-1004 and wild-type cells, over the same regions",
                "shown in Figure 1A. Fold-changes are calculated from the mean",
                "of library-size normalized coverage in non-overlapping 20 nt",
                "windows, averaged over two replicates. Fold-changes with an",
                "absolute value greater than 4 were set to -4 or 4 for",
                "visualization.",
                "(C)",
                "Plots as in (A), but for library-size normalized RNAPII and",
                "Spt6 ChIP-nexus signal.") %>%
        paste(collapse=" ") %>%
        strwrap(width=132) %>%
        paste(collapse="\n") %>%
        textGrob(x=unit(0, "npc"),
                 just="left",
                 gp = gpar(fontsize=8,
                           lineheight=1.05))

    supp_three = arrangeGrob(supp_three_a, supp_three_b, supp_three_c,
                             legends, layout_matrix=layout) %>%
        arrangeGrob(top=textGrob(label = "Supplemental Figure 3: NET-seq", gp=gpar(fontsize=12)))

    ggsave(svg_out, plot=supp_three, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_three, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_three, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_three, file=grob_out)
}

main(three_a = snakemake@input[["three_a"]],
     three_b = snakemake@input[["three_b"]],
     three_c = snakemake@input[["three_c"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
