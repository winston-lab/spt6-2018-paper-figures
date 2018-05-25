
import = function(path, group){
    read_tsv(path) %>%
        transmute(occupancy = smt_value,
                  fuzziness = fuzziness_score,
                  group = group) %>%
        return()
}


main = function(theme_spec,
                wt_mnase_quant, spt6_mnase_quant,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    df = import(wt_mnase_quant, group="WT") %>%
        bind_rows(import(spt6_mnase_quant, group="spt6-1004")) %>%
        mutate(group = fct_inorder(group, ordered=TRUE))

    summary_df = df %>%
        group_by(group) %>%
        summarise(mean_occ = mean(occupancy),
                  sd_occ = sd(occupancy),
                  mean_fuzz = mean(fuzziness),
                  sd_fuzz = sd(fuzziness),
                  median_occ = median(occupancy),
                  median_fuzz = median(fuzziness))

    fig_four_c = ggplot() +
        geom_segment(data = summary_df,
                     aes(x=median_fuzz, xend=median_fuzz,
                         y=0, yend=median_occ, color=group),
                     alpha=0.3, linetype="dashed", size=0.3) +
        geom_segment(data = summary_df,
                     aes(x=35, xend=median_fuzz,
                         y=median_occ, yend=median_occ, color=group),
                     alpha=0.3, linetype="dashed", size=0.3) +
        geom_density2d(data = df,
                       aes(x=fuzziness, y=occupancy,
                           color=group, alpha=log10(..level..)),
                       na.rm=TRUE, h=c(10,10), size=0.3, bins=6) +
        geom_point(data = summary_df,
                   aes(x=median_fuzz, y=median_occ, color=group),
                   size=0.5) +
        scale_color_ptol(guide=guide_legend(keyheight = unit(9, "pt"),
                                            keywidth = unit(12, "pt")),
                         labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_alpha(guide=FALSE, range = c(0.35, 1)) +
        scale_x_continuous(limits = c(35, 70),
                           breaks = scales::pretty_breaks(n=3),
                           expand = c(0,0),
                           name = expression(fuzziness %==% std. ~ dev ~ of ~ dyad ~ positions ~ (bp))) +
        scale_y_continuous(limits = c(0, 200),
                           breaks = scales::pretty_breaks(n=2),
                           labels = function(x){x/1e2},
                           expand = c(0,0),
                           name = "occupancy (au)") +
        ggtitle("nucleosome occupancy + fuzziness") +
        theme_default +
        theme(panel.grid = element_blank(),
              panel.border = element_blank(),
              axis.line = element_line(color="grey65"),
              axis.title.x = element_text(size=7))

    fig_four_c %<>% add_label("C")

    ggsave(svg_out, plot=fig_four_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_four_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_four_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_four_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     wt_mnase_quant = snakemake@input[["wt_mnase_quant"]],
     spt6_mnase_quant = snakemake@input[["spt6_mnase_quant"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

