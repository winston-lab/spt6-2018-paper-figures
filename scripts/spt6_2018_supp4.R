library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(four_a, four_b, four_c,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,2,2,2,2,2),
                   c(1,1,1,1,1,1,1,2,2,2,2,2),
                   c(1,1,1,1,1,1,1,2,2,2,2,2),
                   c(1,1,1,1,1,1,1,2,2,2,2,2),
                   c(1,1,1,1,1,1,1,2,2,2,2,2),
                   c(3,3,3,3,3,3,3,3,3,3,3,3),
                   c(3,3,3,3,3,3,3,3,3,3,3,3),
                   c(3,3,3,3,3,3,3,3,3,3,3,3),
                   c(3,3,3,3,3,3,3,3,3,3,3,3),
                   c(3,3,3,3,3,3,3,3,3,3,3,3),
                   c(3,3,3,3,3,3,3,3,3,3,3,3),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4))

    load(four_a)
    load(four_b)
    load(four_c)
    legends = c("Figure S4. Spt6 mutants have defective chromatin.",
                "(A)",
                "Comparison of spike-in normalized MNase-seq dyad signal in",
                "wild-type and spt6-1004 cells. Panels on the bottom left are",
                "scatterplots of dyad signal in non-overlapping 25 bp bins",
                "with signal in at least one sample, panels on the diagonal",
                "are kernel density estimates of the same signal within each",
                "sample, and panels on the top right are Pearson correlations",
                "of log10(signal), comparing pairwise complete observations.",
                "(B)",
                "Average Mnase-seq dyad signal for the same 3522",
                "nonoverlapping coding genes shown in figure 4A, but grouped",
                "by total sense NET-seq signal in the window extending 500 nt",
                "downstream from the TSS. The solid line and shading represent",
                "the median and the interquartile range.") %>%
        paste(collapse=" ") %>%
        strwrap(width=132) %>%
        paste(collapse="\n") %>%
        textGrob(x=unit(0, "npc"),
                 just="left",
                 gp = gpar(fontsize=8,
                           lineheight=1.05))

    supp_four = arrangeGrob(supp_four_a, supp_four_b, supp_four_c, legends,
                          layout_matrix=layout) %>%
        arrangeGrob(top=textGrob(label = "Supplemental Figure 4: MNase-seq", gp=gpar(fontsize=12)))

    ggsave(svg_out, plot=supp_four, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_four, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_four, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_four, file=grob_out)
}

main(four_a = snakemake@input[["four_a"]],
     four_b = snakemake@input[["four_b"]],
     four_c = snakemake@input[["four_c"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
