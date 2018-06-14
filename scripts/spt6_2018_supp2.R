library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(supp_two_a, supp_two_b, supp_two_c, supp_two_d, supp_two_e,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,1,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,1,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,1,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,1,NA,NA),
                   c(1,1,1,1,1,1,1,1,1,1,NA,NA),
                   c(2,2,2,2,2,2,2,2,2,NA,NA,NA),
                   c(2,2,2,2,2,2,2,2,2,NA,NA,NA),
                   c(2,2,2,2,2,2,2,2,2,NA,NA,NA),
                   c(2,2,2,2,2,2,2,2,2,NA,NA,NA),
                   c(3,3,3,3,3,4,4,4,4,4,NA,NA),
                   c(3,3,3,3,3,4,4,4,4,4,NA,NA),
                   c(3,3,3,3,3,4,4,4,4,4,NA,NA),
                   c(3,3,3,3,3,4,4,4,4,4,NA,NA),
                   c(5,5,5,5,5,5,5,5,5,5,5,5),
                   c(5,5,5,5,5,5,5,5,5,5,5,5),
                   c(5,5,5,5,5,5,5,5,5,5,5,5))

    load(supp_two_a)
    load(supp_two_b)
    load(supp_two_c)
    load(supp_two_d)
    legends = c("Figure S2. ChIP-nexus analysis of TFIIB.",
                "(A)",
                "Comparison of library-sized normalized TFIIB footprints",
                "in wild-type and spt6-1004 cells. Panels on the bottom left",
                "are scatterplots of fragment midpoint signal in",
                "non-overlapping 50 nt bins with signal in at least one",
                "sample, panels on the diagonal are kernel density estimates",
                "of the same signal within each sample, and panels on the top",
                "right are Pearson correlations of log10(signal), comparing",
                "pairwise complete observations.",
                "(B)",
                "Same plots as in (A), except comparing ChIP-nexus to ChIP-exo",
                "(Rhee and Pugh, 2012).",
                "(C)",
                "Average TFIIB ChIP-nexus signal in wild-type cells",
                "(grown at 37C for 80 min), aligned to 572 TATA boxes with no",
                "mismatches to the sequence TATAWAWR as previously defined",
                "(Rhee and Pugh, 2012). The signal around each TATA box is",
                "scaled from zero to one before averaging to normalize",
                "differences in levels of TFIIB binding. Values shown are the",
                "mean over TATA boxes. Crosslinking signal on the plus and",
                "minus strand are plotted above and below the x-axis,",
                "respectively.",
                "(D)",
                "(left panel) Western analysis of TFIIB protein levels in wild",
                "type and spt6-1004. Protein levels were quantified using",
                "anti-SPA antibody to detect the TAP tag on TFIIB and anti-Myc",
                "to detect Dst1 from a spike-in strain (see Methods).",
                "(right panel) Quantification of Spt6 protein levels for three",
                "Westerns. Each bar shows the mean and standard deviation of",
                "three replicates.") %>%
        paste(collapse=" ") %>%
        strwrap(width=132) %>%
        paste(collapse="\n") %>%
        textGrob(x=unit(0, "npc"),
                 just="left",
                 gp = gpar(fontsize=8,
                           lineheight=1.05))

    supp_two = arrangeGrob(supp_two_a, supp_two_b, supp_two_c, supp_two_d,
                           legends, layout_matrix=layout) %>%
        arrangeGrob(top=textGrob(label = "Supplemental Figure 2: TFIIB ChIP-nexus",
                                 gp=gpar(fontsize=12)))

    ggsave(svg_out, plot=supp_two, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_two, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_two, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_two, file=grob_out)
}

main(supp_two_a = snakemake@input[["supp_two_a"]],
     supp_two_b = snakemake@input[["supp_two_b"]],
     supp_two_c = snakemake@input[["supp_two_c"]],
     supp_two_d = snakemake@input[["supp_two_d"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
