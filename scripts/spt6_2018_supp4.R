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
                   c(3,3,3,3,3,3,3,3,3,3,3,3))

    load(four_a)
    load(four_b)
    load(four_c)

    supp_four = arrangeGrob(supp_four_a, supp_four_b, supp_four_c,
                          layout_matrix=layout)

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
