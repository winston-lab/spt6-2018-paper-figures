library(ggplot2)
library(grid)
library(gridExtra)

main = function(fig_five_a, fig_five_b, fig_five_c,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,3,3,3,3,3,3),
                   c(1,1,1,1,1,1,3,3,3,3,3,3),
                   c(1,1,1,1,1,1,3,3,3,3,3,3),
                   c(1,1,1,1,1,1,3,3,3,3,3,3),
                   c(1,1,1,1,1,1,NA,NA,NA,NA,NA,NA),
                   c(1,1,1,1,1,1,NA,NA,NA,NA,NA,NA),
                   c(1,1,1,1,1,1,4,4,4,4,4,4),
                   c(2,2,2,2,2,NA,4,4,4,4,4,4),
                   c(2,2,2,2,2,NA,4,4,4,4,4,4),
                   c(2,2,2,2,2,NA,4,4,4,4,4,4),
                   c(2,2,2,2,2,5,5,5,5,5,5,5),
                   c(5,5,5,5,5,5,5,5,5,5,5,5))

    load(fig_five_a)
    load(fig_five_b)
    load(fig_five_c)
    fig_five_d = textGrob(label="5D: motif enrichment")
    placeholder = textGrob(label = ".")

    fig_five = arrangeGrob(fig_five_a, fig_five_b, fig_five_c, fig_five_d, placeholder,
                          layout_matrix=layout)

    ggsave(svg_out, plot=fig_five, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_five, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_five, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_five, file=grob_out)
}

main(fig_five_a = snakemake@input[["fig_five_a"]],
     fig_five_b = snakemake@input[["fig_five_b"]],
     fig_five_c = snakemake@input[["fig_five_c"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
