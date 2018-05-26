
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        group_by(group, annotation, index, position) %>%
        summarise(signal = mean(signal)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("WT-37C", "spt6-1004-37C"),
                               labels = c("WT", "italic(\"spt6-1004\")"))) %>%
        return()
}

plot_heatmap = function(df, max_length, add_ylabel, y_label="", cutoff_pct, colorbar_title){
    label_df = df %>%
        group_by(group) %>%
        summarise(sorted_index = max(sorted_index),
                  position = max(position))

    heatmap = ggplot() +
        geom_raster(data=df, aes(x=position, y=sorted_index, fill=signal),
                    interpolate=FALSE) +
        geom_text(data=label_df, aes(x=1, y=sorted_index, label=group),
                  hjust=0, nudge_y=-250, size=9/72*25.4, parse=TRUE) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           expand = c(0, 0.05),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          x==max_length ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))}) +
        scale_y_continuous(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                           name = if(add_ylabel){paste(n_distinct(df[["sorted_index"]]), y_label)} else {""},
                           expand = c(0, 0)) +
        scale_fill_distiller(palette = "PuBu", direction=1,
                             limits = c(NA, quantile(df[["signal"]], cutoff_pct)),
                             breaks = scales::pretty_breaks(n=3),
                             oob = scales::squish,
                             name = colorbar_title,
                             guide = guide_colorbar(title.position="top",
                                                    barwidth=8,
                                                    barheight=0.3,
                                                    title.hjust=0.5)) +
        facet_grid(.~group, labeller=label_parsed) +
        theme_heatmap
    return(heatmap)
}

