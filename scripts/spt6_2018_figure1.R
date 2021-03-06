library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(one_a, one_b, one_c, one_d,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(2,2,2,3,3,3,3,3,3,3,3,3),
                   c(2,2,2,3,3,3,3,3,3,3,3,3),
                   c(2,2,2,3,3,3,3,3,3,3,3,3),
                   c(2,2,2,3,3,3,3,3,3,3,3,3),
                   c(2,2,2,3,3,3,3,3,3,3,3,3))

    load(one_a)
    load(one_b)
    load(one_c)
    load(one_d)

    fig_one = arrangeGrob(fig_one_a, fig_one_b,
                          arrangeGrob(fig_one_c, fig_one_d, nrow=1),
                          layout_matrix=layout)

    ggsave(svg_out, plot=fig_one, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one, file=grob_out)
}

main(one_a = snakemake@input[["one_a"]],
     one_b = snakemake@input[["one_b"]],
     one_c = snakemake@input[["one_c"]],
     one_d = snakemake@input[["one_d"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
