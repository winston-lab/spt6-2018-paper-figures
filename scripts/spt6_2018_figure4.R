library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(four_a, four_b, four_c, four_d,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,NA,2,2,2,2,2,NA,NA),
                   c(1,1,1,1,NA,2,2,2,2,2,NA,NA),
                   c(1,1,1,1,NA,2,2,2,2,2,NA,NA),
                   c(3,3,3,3,NA,2,2,2,2,2,NA,NA),
                   c(3,3,3,3,NA,2,2,2,2,2,NA,NA),
                   c(3,3,3,3,NA,2,2,2,2,2,NA,NA),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4),
                   c(4,4,4,4,4,4,4,4,4,4,4,4))

    load(four_a)
    load(four_b)
    load(four_c)
    load(four_d)

    fig_four = arrangeGrob(fig_four_a, fig_four_b, fig_four_c, fig_four_d,
                          layout_matrix=layout) %>%
        arrangeGrob(top=textGrob(label = "Figure 4: MNase-seq", gp=gpar(fontsize=12)))

    ggsave(svg_out, plot=fig_four, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_four, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_four, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_four, file=grob_out)
}

main(four_a = snakemake@input[["four_a"]],
     four_b = snakemake@input[["four_b"]],
     four_c = snakemake@input[["four_c"]],
     four_d = snakemake@input[["four_d"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
