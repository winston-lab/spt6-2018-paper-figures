
main = function(theme_spec,
                diffexp_results, positions,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(broom)
    digits = 2

    # can't do a KS test because positions on DNA are discrete
    # so I bin the data into the nearest tenth of a percentage along the gene body
    # and do permutation test on chi-sq test statistic

    df = read_tsv(diffexp_results) %>%
        count(round(atg_to_peak_dist/(orf_end-orf_start), digits)) %>%
        magrittr::set_colnames(c("rel_dist", "observed")) %>%
        full_join(read_tsv(positions) %>%
                      group_by(index=round(index, digits)) %>%
                      summarise(expected = sum(count)),
                  by=c("rel_dist"="index")) %>%
        filter(rel_dist %>% between(0, 1)) %>%
        replace_na(list(expected=as.integer(0), observed=as.integer(0))) %>%
        mutate(expected = expected/sum(expected)*sum(observed))

    test_results = chisq.test(x=df[["observed"]],
                              p=df[["expected"]],
                              rescale.p = TRUE,
                              simulate.p.value = TRUE) %>%
        tidy()

    supp_one_e = ggplot(data = df %>% gather(key=count_type, value=n, -rel_dist),
           aes(x=rel_dist, y=n, color=count_type)) +
        geom_smooth(span=0.1, se=FALSE, alpha=0.9, size=0.8) +
        # geom_vline(xintercept = c(0, 1),
        #            color="grey65") +
        annotate(geom="label", x=0.05, y=85,
                 label=test_results[["p.value"]] %>%
                     scales::scientific() %>%
                     paste0("p=", .),
                 hjust=0, label.size=NA, label.r=unit(0, "pt"),
                 size = 7/72*25.4) +
        scale_x_continuous(breaks = c(0, 1),
                           labels = c("ATG", "stop codon"),
                           expand = c(0,0)) +
        ylab("number of TSSs") +
        # ggtitle(expression(intragenic ~ TSSs ~ upregulated ~ "in" ~ italic("spt6-1004"))) +
        scale_color_tableau(guide=guide_legend(reverse=TRUE)) +
        theme_default +
        theme(legend.position = c(0.05, 0.90),
              legend.key.height = unit(8, "pt"),
              legend.justification = c(0, 0.5),
              axis.title.x = element_blank())

    supp_one_e %<>% add_label("E")

    ggsave(svg_out, plot=supp_one_e, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one_e, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one_e, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one_e, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     diffexp_results = snakemake@input[["diffexp_results"]],
     positions = snakemake@input[["positions"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

