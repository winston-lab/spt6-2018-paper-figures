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
                   c(3,3,3,3,3,4,4,4,4,4,NA,NA))

    load(supp_two_a)
    load(supp_two_b)
    load(supp_two_c)
    load(supp_two_d)

    supp_two = arrangeGrob(supp_two_a, supp_two_b, supp_two_c, supp_two_d,
                           layout_matrix=layout)

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
