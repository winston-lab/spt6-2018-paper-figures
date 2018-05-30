library(ggplot2)
library(grid)
library(gridExtra)

main = function(three_a, three_b, three_c, fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,3,3,3,3,3,3),
                   c(2,2,2,2,2,2,NA,NA,NA,NA,NA,NA),
                   c(2,2,2,2,2,2,NA,NA,NA,NA,NA,NA),
                   c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA),
                   c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA))

    load(three_a)
    load(three_b)
    load(three_c)

    supp_three = arrangeGrob(supp_three_a, supp_three_b, supp_three_c, layout_matrix=layout)

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
