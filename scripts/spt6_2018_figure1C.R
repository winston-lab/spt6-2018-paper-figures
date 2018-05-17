
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
                  hjust=0, nudge_y=-500, size=9/72*25.4, parse=TRUE) +
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

main = function(theme_spec, sense_tss_data, antisense_tss_data, annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)

    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")

    anno = read_tsv(annotation,
                    col_names = c('chrom', 'start', 'end', 'name', 'score', 'strand')) %>%
        rowid_to_column(var="index") %>%
        arrange(desc(end-start)) %>%
        rowid_to_column(var="sorted_index") %>%
        select(index, sorted_index)

    sense_df = import(sense_tss_data, sample_list=sample_list) %>% left_join(anno, by="index")
    anti_df = import(antisense_tss_data, sample_list=sample_list) %>% left_join(anno, by="index")

    sense_heatmap = plot_heatmap(df=sense_df, max_length=3, add_ylabel=TRUE, cutoff_pct=0.95,
                                 y_label="coding genes", colorbar_title="sense TSS-seq signal")
    anti_heatmap = plot_heatmap(df=anti_df, max_length=3, add_ylabel=FALSE, cutoff_pct=0.95,
                                 colorbar_title="antisense TSS-seq signal")
    fig_one_c = arrangeGrob(sense_heatmap, anti_heatmap, nrow=1) %>%
        add_label("c")

    ggsave(svg_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_one_c, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     sense_tss_data = snakemake@input[["sense_tss_data"]],
     antisense_tss_data = snakemake@input[["antisense_tss_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

