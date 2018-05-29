library(ggplot2)
library(grid)
library(gridExtra)

main = function(one_a, one_c,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,1,1,1,2,2,2),
                   c(1,1,1,1,1,1,4,4,4,4,4,4),
                   c(3,3,3,3,3,3,4,4,4,4,4,4),
                   c(3,3,3,3,3,3,4,4,4,4,4,4),
                   c(3,3,3,3,3,3,4,4,4,4,4,4),
                   c(3,3,3,3,3,3,4,4,4,4,4,4),
                   c(NA,NA,NA,NA,NA,NA,4,4,4,4,4,4))

    load(one_a)
    fig_one_b = textGrob(label = "1B: Spt6 western")
    load(one_c)
    fig_one_d = textGrob(label = "1D: 3' bias of intragenic sense")

    fig_one = arrangeGrob(fig_one_a, fig_one_b, fig_one_c, fig_one_d, layout_matrix=layout)

    ggsave(svg_out, plot=fig_one, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one, file=grob_out)
}

main(one_a = snakemake@input[["one_a"]],
     one_c = snakemake@input[["one_c"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
