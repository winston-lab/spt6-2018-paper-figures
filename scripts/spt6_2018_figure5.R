library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(five_a, five_b, five_c, five_d, five_e,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    library(ggrepel)
    layout = rbind(c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(3,3,3,3,3,3,5,5,5,5,5,5),
                   c(3,3,3,3,3,3,5,5,5,5,5,5),
                   c(3,3,3,3,3,3,5,5,5,5,5,5),
                   c(4,4,4,4,4,4,5,5,5,5,5,5),
                   c(4,4,4,4,4,4,5,5,5,5,5,5),
                   c(4,4,4,4,4,4,5,5,5,5,5,5))

    load(five_a)
    load(five_b)
    load(five_c)
    load(five_d)
    load(five_e)

    fig_five = arrangeGrob(fig_five_a, fig_five_b, fig_five_c, fig_five_d, fig_five_e,
                          layout_matrix=layout)

    ggsave(svg_out, plot=fig_five, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_five, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_five, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_five, file=grob_out)
}

main(five_a = snakemake@input[["five_a"]],
     five_b = snakemake@input[["five_b"]],
     five_c = snakemake@input[["five_c"]],
     five_d = snakemake@input[["five_d"]],
     five_e = snakemake@input[["five_e"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
