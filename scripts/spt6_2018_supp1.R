library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(supp_one_a, supp_one_b, supp_one_c, supp_one_d, supp_one_e, supp_one_f,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,NA,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,NA,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,NA,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,NA,NA,NA),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(7,7,7,7,7,7,7,7,7,7,7,7),
                   c(7,7,7,7,7,7,7,7,7,7,7,7),
                   c(7,7,7,7,7,7,7,7,7,7,7,7),
                   c(7,7,7,7,7,7,7,7,7,7,7,7))

    load(supp_one_a)
    load(supp_one_b)
    load(supp_one_c)
    load(supp_one_d)
    load(supp_one_e)
    load(supp_one_f)
    legends = c("Figure S1. TSS-seq comparisons.",
                "(A)",
                "Comparison of spike-in normalized TSS-seq signal in wild-type",
                "and spt6-1004 cells. Panels on the bottom left are",
                "scatterplots of the signal in all bins with signal in at",
                "least one sample, panels on the diagonal are kernel density",
                "estimates of the same signal within each sample, and panels",
                "on the top right are Pearson correlations of log10(signal),",
                "comparing pairwise complete observations.",
                "(B)",
                "Average relative TSS-seq signal over 5088 coding genes,",
                "comparing wild-type samples from this work",
                "(grown at 37C for 80 min) to previously published wild-type",
                "samples (Malabat et al., 2015). For each gene, the signal in",
                "the window from TSS-500nt to CPS+500nt is scaled from 0 to 1",
                "before averaging. The solid line and shaded area represent",
                "the median and the interdecile range. Signals are offset by",
                "140nt for visualization of the signal at the TSS",
                "(TO BE CHANGED).",
                "(C)",
                "Scatterplot of 5088 coding genes in wild-type, comparing" ,
                "TSS-seq signal in the 60 nt window centered on the annotated",
                "TSS to RNA-seq signal over the whole transcript, using data",
                "from (Uwimana et al., 2017).",
                "(D)",
                "Histogram of the number of intragenic TSSs upregulated in",
                "spt6-1004 per open reading frame.",
                "(E)",
                "Set diagram showing the overlap of individual genes reported",
                "to have intragenic starts using tiled arrays",
                "(Cheung et al., 2008), RNA-seq (Uwimana et al., 2017), and",
                "TSS-seq (this work). The universal overlap is represented by",
                "the center circle and pairwise overlaps are represented by",
                "the circles between datasets. The size of each circle is",
                "proportional to the number of genes in each set.") %>%
        paste(collapse=" ") %>%
        strwrap(width=132) %>%
        paste(collapse="\n") %>%
        textGrob(x=unit(0, "npc"),
                 just="left",
                 gp = gpar(fontsize=8,
                           lineheight=1.05))

    supp_one = arrangeGrob(supp_one_a, supp_one_b, supp_one_c, supp_one_d,
                           supp_one_e, supp_one_f, legends,
                          layout_matrix=layout) %>%
        arrangeGrob(top=textGrob(label = "Supplemental Figure 1: TSS-seq", gp=gpar(fontsize=12)))

    ggsave(svg_out, plot=supp_one, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one, file=grob_out)
}

main(supp_one_a = snakemake@input[["supp_one_a"]],
     supp_one_b = snakemake@input[["supp_one_b"]],
     supp_one_c = snakemake@input[["supp_one_c"]],
     supp_one_d = snakemake@input[["supp_one_d"]],
     supp_one_e = snakemake@input[["supp_one_e"]],
     supp_one_f = snakemake@input[["supp_one_f"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
