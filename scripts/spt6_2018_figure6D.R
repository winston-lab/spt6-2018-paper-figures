
main = function(theme_spec, data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    
    df = read_tsv(data_path,
                  col_types = 'ccd') %>% 
        mutate(strain = ordered(strain,
                                levels = c("spt6-AID2 DMSO", "spt6-AID2 IAA", "spt6-1004")))
    
    fig_six_d = ggplot(data = df, aes(x=strain,
                          group=interaction(strain,temperature),
                          color=temperature, y=value)) +
        annotate(geom="rect", xmin=0.5, xmax=2.5, ymin=-40, ymax=max(df[["value"]]*1.05),
                 fill="grey65", alpha=0.5) +
        annotate(geom="text", x=1.5, y=-20, label="italic(\"Spt6-AID2\")", parse=TRUE,
                 size=7/72*25.4) +
        annotate(geom="text", x=3, y=-20, label="italic(\"spt6-1004\")", parse=TRUE,
                 size=7/72*25.4) +
        geom_boxplot(width=0.5,
                     position = position_dodge(width=0.5),
                     color="black",
                     size=0.4) +
        geom_point(position=position_jitterdodge(dodge.width=0.6,
                                                 jitter.width=0.3),
                   size=1, alpha=0.8) +
        scale_x_discrete(labels = c("DMSO", "IAA", ""),
                         expand=c(0,0.3)) +
        scale_y_continuous(limits = c(-40, max(df[["value"]]*1.05)),
                           expand = c(0,0),
                           name = "????????") +
        scale_color_tableau(labels = c(bquote(30*degree*C), bquote(37*degree*C))) +#,
                            # guide=guide_legend(label.position="bottom",
                            #                    label.hjust=0.5,
                            #                    keywidth=2)) +
        scale_fill_tableau(labels = c(bquote(30*degree*C), bquote(37*degree*C))) +#,
                            # guide=guide_legend(label.position="bottom",
                            #                    label.hjust=0.5,
                            #                    keywidth=2)) +
        ggtitle("SSA4 RT-qPCR") +
        theme_default +
        theme(axis.title.x = element_blank(),
              legend.position = c(0.03, 0.99),
              legend.justification = c(0,1),
              legend.key = element_blank(),
              legend.key.height = unit(10, "pt"))
       
    fig_six_d %<>% add_label("D")
    
    ggsave(svg_out, plot=fig_six_d, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_six_d, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_six_d, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_six_d, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
