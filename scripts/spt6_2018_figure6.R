library(ggplot2)
library(grid)
library(gridExtra)

main = function(six_a, six_b, six_c, six_d,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    layout = rbind(c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(1,1,1,1,1,1,1,1,1,1,1,1),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,3,3,3,3,3,3,3),
                   c(2,2,2,2,2,4,4,4,4,4,4,4),
                   c(2,2,2,2,2,4,4,4,4,4,4,4),
                   c(2,2,2,2,2,4,4,4,4,4,4,4))

    load(six_a)
    load(six_b)
    load(six_c)
    load(six_d)

    fig_six = arrangeGrob(fig_six_a, fig_six_b, fig_six_c, fig_six_d, layout_matrix=layout)

    ggsave(svg_out, plot=fig_six, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six, file=grob_out)
}

main(six_a = snakemake@input[["six_a"]],
     six_b = snakemake@input[["six_b"]],
     six_c = snakemake@input[["six_c"]],
     six_d = snakemake@input[["six_d"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
