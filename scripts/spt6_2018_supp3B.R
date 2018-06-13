
import = function(path, sample_list, strand_id){
    read_tsv(path, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        group_by(group, annotation, index, position) %>%
        summarise(signal = mean(signal)) %>%
        ungroup() %>%
        mutate(strand = strand_id) %>%
        return()
}

main = function(theme_spec, sense_netseq_data, antisense_netseq_data,
                annotation,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(pals)
    sample_list = c("WT-37C-1", "WT-37C-2", "spt6-1004-37C-1", "spt6-1004-37C-2")
    max_length = 3
    cps_dist = 0.3

    bed = read_tsv(annotation,
                   col_names = c('chrom', 'start', 'end',
                                 'name', 'score', 'strand')) %>%
        rowid_to_column(var="index") %>%
        arrange(desc(end-start)) %>%
        rowid_to_column(var="sorted_index") %>%
        mutate(cps_position = (end-start)/1000-cps_dist)

    df = import(sense_netseq_data, sample_list=sample_list, strand="sense") %>%
        bind_rows(import(antisense_netseq_data, sample_list=sample_list, strand="antisense")) %>%
        spread(group, signal) %>%
        mutate(ratio = log2((`spt6-1004-37C`+0.01)/(`WT-37C`+0.01)),
               strand = ordered(strand, levels = c("sense", "antisense"))) %>%
        left_join(bed %>% select(index, sorted_index), by="index")

    supp_three_b = ggplot() +
        geom_raster(data = df, aes(x=position, y=sorted_index, fill=ratio)) +
        geom_path(data = bed %>% filter(cps_position <= max_length) %>%
                      select(-strand),
                     aes(x=cps_position, y=sorted_index),
                  size=0.3, linetype="dotted", alpha=0.9, color="black") +
        geom_text(data = tibble(strand = ordered(c("sense", "antisense"),
                                                 levels=c("sense", "antisense"))),
                  aes(x=1, y=max(df[["sorted_index"]]), label=strand),
                  nudge_y=-250, size=9/72*25.4, hjust=0) +
        facet_grid(.~strand) +
        scale_fill_gradientn(colors=coolwarm(100),
                             limits = c(-2, 2),
                             oob = scales::squish,
                             breaks = scales::pretty_breaks(n=3),
                             name = expression("NET-seq" ~ log[2] ~ textstyle(frac(italic("spt6-1004"), "WT"))),
                             guide=guide_colorbar(title.position = "top",
                                                  barwidth=8, barheight=0.3, title.hjust=0.5)) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          x==3 ~ "3kb",
                                                          TRUE ~ as.character(x))},
                           expand = c(0, 0.05)) +
        scale_y_continuous(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                           name = paste(n_distinct(df[["sorted_index"]]), "nonoverlapping coding genes"),
                           expand = c(0,0)) +
        theme_heatmap

    supp_three_b %<>% add_label("B")

    ggsave(svg_out, plot=supp_three_b, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_three_b, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_three_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_three_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     sense_netseq_data = snakemake@input[["sense_netseq_data"]],
     antisense_netseq_data = snakemake@input[["antisense_netseq_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

