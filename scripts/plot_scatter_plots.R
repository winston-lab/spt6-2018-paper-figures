library(tidyverse)
library(GGally)
library(viridis)

import = function(path, sample_list, netseq=FALSE, chipnexus=FALSE){

    read_tsv(path) %>%
        gather(key=sample, value=signal, -name) %>%
        filter(sample %in% sample_list) %>%
        mutate(sample = ordered(sample,
                                levels = if(netseq){
                                    c("WT-37C-1", "WT-37C-2",
                                      "spt6-1004-30C-1", "spt6-1004-30C-2",
                                      "spt6-1004-37C-1", "spt6-1004-37C-2",
                                      "set2D")
                                } else if (chipnexus){
                                    c("rnapii_YPD-1", "rnapii_YPD-2",
                                      "spt6_YPD-1", "spt6_YPD-2")
                                } else {
                                    c("WT-37C-1", "WT-37C-2",
                                      "spt6-1004-37C-1", "spt6-1004-37C-2")
                                    },
                                labels = if(netseq){
                                    c("\"WT\" ~ 37*degree ~ 1",
                                      "\"WT\" ~ 37*degree ~ 2",
                                      "italic(\"spt6-1004\") ~ 30*degree ~ 1",
                                      "italic(\"spt6-1004\") ~ 30*degree ~ 2",
                                      "italic(\"spt6-1004\") ~ 37*degree ~ 1",
                                      "italic(\"spt6-1004\") ~ 37*degree ~ 2",
                                      "italic(\"set2\"*Delta)")
                                    } else if (chipnexus) {
                                        c("\"Rpb1 1\"", "\"Rpb1 2\"",
                                          "\"Spt6 1\"", "\"Spt6 2\"")
                                } else {
                                    c("\"WT 1\"", "\"WT 2\"",
                                      "italic(\"spt6-1004\") ~ 1",
                                      "italic(\"spt6-1004\") ~ 2")
                                })) %>%
        spread(sample, signal) %>%
        select(-name) %>%
        .[which(rowSums(.)>0),] %>%
        return()
}

plot_scatter = function(data_path, sample_list, title, pcount, genome_binsize, plot_binwidth, netseq=FALSE, chipnexus=FALSE){

    df = import(data_path, sample_list=sample_list, netseq=netseq, chipnexus=chipnexus)

    cor_matrix = df %>% na_if(0) %>% log10() %>%
        cor(method="pearson", use="pairwise.complete.obs")

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
                        scale_y_continuous(breaks=c(0,1),
                                           limits = c(0, 1.05),
                                           expand = c(0,0)) +
                        scale_x_log10(limits = c(pcount, max_signal*1.1),
                                      expand = c(0,0.1),
                                      labels = scales::comma) +
                        annotate("label", x=.90*max_signal, y=0.5, hjust=1,
                                 label=names(df)[i], size=7/72*25.4, fontface="plain",
                                 label.size = NA, label.r=unit(0,"pt"), label.padding=unit(0.25,"pt"),
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
                                 binwidth=rep(plot_binwidth,2), size=.05, alpha=0.8) +
                    scale_fill_viridis(option="inferno") +
                    scale_color_viridis(option="inferno") +
                    scale_x_log10(limits = c(pcount, max_signal*1.1),
                                  expand = c(0,0.1),
                                  labels = scales::comma) +
                    scale_y_log10(limits = c(pcount, max_signal*1.1),
                                  expand = c(0,0.1),
                                  labels = scales::comma)
                plots[[idx]] = plot
            }
        }
    }

    all_plots = ggmatrix(plots, nrow=ncol(df), ncol=ncol(df),
                   title = paste0(title, ", ", genome_binsize),
                   xAxisLabels = names(df), yAxisLabels = names(df), switch="both",
                   labeller=label_parsed) +
        theme_light() +
        theme(plot.title = element_text(size=9, color="black", face="plain", margin = margin(0,0,0,0, "pt")),
              axis.text = element_text(size=5, margin = margin(0,0,0,0,"pt")),
              axis.title = element_blank(),
              strip.background = element_blank(),
              strip.text = element_text(size=7, color="black"),
              strip.text.x = element_text(margin = margin(3, 0, 0, 0, "pt")),
              strip.text.y = element_text(angle=180, hjust=1, margin = margin(0, 2, 0, 0, "pt")),
              strip.placement="outside",
              strip.switch.pad.grid = unit(0, "points"),
              strip.switch.pad.wrap = unit(0, "points"),
              plot.margin = margin(0,0,0,0, "pt"),
              panel.spacing = unit(0, "pt"),
              panel.border = element_rect(size=0.25),
              panel.grid.minor = element_blank())

    return(ggmatrix_gtable(all_plots))
}
