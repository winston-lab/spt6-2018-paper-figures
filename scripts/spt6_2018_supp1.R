library(ggplot2)
library(magrittr)
library(grid)
library(gridExtra)

main = function(supp_one_a, supp_one_b, supp_one_c, supp_one_d, supp_one_e, supp_one_f,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(4,4,4,4,5,5,5,5,6,6,6,6),
                   c(4,4,4,4,5,5,5,5,6,6,6,6))

    load(supp_one_a)
    load(supp_one_b)
    load(supp_one_c)
    load(supp_one_d)
    load(supp_one_e)
    load(supp_one_f)

    supp_one = arrangeGrob(supp_one_a, supp_one_b, supp_one_c, supp_one_d,
                           supp_one_e, supp_one_f,
                          layout_matrix=layout)

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
