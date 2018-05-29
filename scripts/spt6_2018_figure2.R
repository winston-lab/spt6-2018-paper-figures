library(ggplot2)
library(grid)
library(gridExtra)

main = function(two_a, two_b, two_d, two_e,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,3,3,3,3,3,3,3),
                   c(1,1,1,1,1,3,3,3,3,3,3,3),
                   c(1,1,1,1,1,3,3,3,3,3,3,3),
                   c(1,1,1,1,1,3,3,3,3,3,3,3),
                   c(1,1,1,1,1,4,4,4,4,4,4,4),
                   c(1,1,1,1,1,4,4,4,4,4,4,4),
                   c(1,1,1,1,1,4,4,4,4,4,4,4),
                   c(2,2,2,2,2,4,4,4,4,4,4,4),
                   c(2,2,2,2,2,NA,NA,5,5,5,5,5),
                   c(2,2,2,2,2,NA,NA,5,5,5,5,5),
                   c(2,2,2,2,2,NA,NA,5,5,5,5,5),
                   c(2,2,2,2,2,NA,NA,5,5,5,5,5))
    
    load(two_a)
    load(two_b)
    fig_two_c = textGrob(label = "2C: example of TFIIB spreading")
    load(two_d)
    load(two_e)
    
    fig_two = arrangeGrob(fig_two_a, fig_two_b, fig_two_c, fig_two_d, fig_two_e,
                          layout_matrix=layout)

    ggsave(svg_out, plot=fig_two, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_two, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_two, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_two, file=grob_out)
}

main(two_a = snakemake@input[["two_a"]],
     two_b = snakemake@input[["two_b"]],
     two_d = snakemake@input[["two_d"]],
     two_e = snakemake@input[["two_e"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
