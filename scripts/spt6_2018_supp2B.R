
main = function(theme_spec, data_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(GGally)

    df = read_tsv(data_path) %>%
        gather(key=sample, value=signal, -name) %>%
        mutate(sample = ordered(sample,
                                levels = c("ChIP-nexus-1", "ChIP-nexus-2", "ChIP-exo-1"),
                                labels = c("\"ChIP-nexus 1\"", "\"ChIP-nexus 2\"", "\"ChIP-exo 1\""))) %>%
        spread(sample, signal) %>%
        select(-name) %>%
        .[which(rowSums(.)>0),]

    cor_matrix = df %>% na_if(0) %>% log10() %>%
        cor(method="pearson", use="pairwise.complete.obs")

    pcount = 0.1
    max_signal = max(df) + pcount
    min_cor = min(cor_matrix) * 0.98
    plots = list()

    #for each column, indexed by i
    for (i in 1:ncol(df)) {
        #for each row, indexed by j
        for (j in 1:ncol(df)) {
            idx = ncol(df)*(i-1)+j

            if (i < j) {
                #upper right (correlation)
                cor_value = cor_matrix[i,j]
                plot = ggplot(data = tibble(x=c(0,1), y=c(0,1), corr=cor_value)) +
                    geom_rect(aes(fill=corr), xmin=0, ymin=0, xmax=1, ymax=1) +
                    # annotate("text", x=0.5, y=0.5, label=sprintf("%.2f",round(c,2)), size=9/72*25.4*c) +
                    annotate("text", x=0.5, y=0.5, label=sprintf("%.2f",round(cor_value,2)), size=14/72*25.4) +
                    scale_x_continuous(breaks=NULL) +
                    scale_y_continuous(breaks=NULL) +
                    scale_fill_distiller(palette="Blues", limits = c(min_cor,1), direction=1)
                plots[[idx]] = plot
            } else if (i == j) {
                #top left to bot right diag (density)
                sub_df = df %>% select(value=i)
                plot = ggplot(data = sub_df, aes(x=(value+pcount))) +
                        geom_density(aes(y=..scaled..), fill="#114477", color="#114477", size=0.1) +
                        scale_y_continuous(breaks=c(0,1)) +
                        scale_x_log10(limit = c(pcount, max_signal)) +
                        annotate("label", x=.90*max_signal, y=0.5, hjust=1,
                                 label=names(df)[i], size=7/72*25.4, fontface="plain",
                                 label.size = 0, label.r=unit(0,"pt"), label.padding=unit(0.25,"pt"),
                                 parse=TRUE)
                plots[[idx]] = plot
            } else {
                #bottom left (scatter)
                sub_df = df %>%
                    select(x_values=j, y_values=i) %>%
                    .[which(rowSums(.)>0),]

                plot = ggplot(data = sub_df,
                              aes(x=x_values+pcount, y=y_values+pcount)) +
                    geom_abline(intercept = 0, slope=1, color="grey80", size=.5) +
                    stat_bin_hex(geom="point", aes(color=log10(..count..)),
                                 binwidth=rep(0.05,2), size=.25, shape=16, alpha=0.8) +
                    scale_fill_viridis(option="inferno") +
                    scale_color_viridis(option="inferno") +
                    scale_x_log10(limit = c(pcount, max_signal)) +
                    scale_y_log10(limit = c(pcount, max_signal))
                plots[[idx]] = plot
            }
        }
    }

    supp_two_b = ggmatrix(plots, nrow=ncol(df), ncol=ncol(df),
                   title = expression(WT~ 30*degree*C ~ TFIIB ~ signal*"," ~ "50nt bins"),
                   xAxisLabels = names(df), yAxisLabels = names(df), switch="both",
                   labeller=label_parsed) +
        theme_light() +
        theme(plot.title = element_text(size=9, color="black", face="plain", margin = margin(0,0,0,0, "pt")),
              axis.text = element_text(size=5, margin=margin(0,0,0,0,"pt")),
              axis.title = element_blank(),
              strip.background = element_blank(),
              strip.text = element_text(size=7, color="black", margin=margin(0,0,0,0,"pt")),
              strip.text.y = element_text(angle=180, hjust=1),
              strip.placement="outside",
              strip.switch.pad.grid = unit(0, "points"),
              strip.switch.pad.wrap = unit(0, "points"),
              plot.margin = margin(0,0,0,0, "pt"),
              panel.spacing = unit(0, "pt"),
              panel.border = element_rect(size=0.5),
              panel.grid.minor = element_blank())

    supp_two_b %<>%
        ggmatrix_gtable() %>%
        add_label("B")

    ggsave(svg_out, plot=supp_two_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_two_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_two_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_two_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

