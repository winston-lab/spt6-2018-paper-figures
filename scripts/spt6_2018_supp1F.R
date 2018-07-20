
#modified from Raivo Kolde's 'bvenn' R package
#https://cran.r-project.org/web/packages/bvenn/index.html
list2table3l = function(l1, l2, l3){
    numbers = c(length(intersect(setdiff(l1, l2), setdiff(l1, l3))),
                length(intersect(setdiff(l2, l1), setdiff(l2, l3))),
                length(intersect(setdiff(l3, l1), setdiff(l3, l2))),
                length(setdiff(intersect(l1, l2), l3)),
                length(setdiff(intersect(l1, l3), l2)),
                length(setdiff(intersect(l3, l2), l1)),
                length(intersect(intersect(l1, l2), l3)))
    percentage = round(numbers / sum(numbers), 2) * 100
    return(tibble(numbers = numbers, percentage = percentage))
}

#modified for ggplot graphics from Raivo Kolde's 'bvenn' R package
#https://cran.r-project.org/web/packages/bvenn/index.html
bvenn = function(lists, scale=1, title){
    x = (c(0.20, 0.50, 0.80, 0.35, 0.50, 0.65, 0.50) - 0.5) * scale + 0.5
    y = (c(0.800, 0.284, 0.800, 0.536, 0.800, 0.536, 0.632) - 0.5) * scale + 0.5
    data = tibble(x, y) %>%
        bind_cols(list2table3l(lists[[1]], lists[[2]], lists[[3]])) %>%
        mutate(radius= sqrt(percentage)/10 * 0.23, point=paste0("point",row_number()))
    triangle = data %>%
        slice(c(1,2,3,1,7,7)) %>%
        select(x,y) %>%
        bind_cols(data %>%
                      slice(c(2,3,1,7,3,2)) %>%
                      select(xend=x, yend=y))

    labels = data %>%
        slice(1:3) %>%
        bind_cols(name=names(lists))

    labels[c(1,3),"y"] = labels[c(1,3),"y"] + max(labels[c(1,3),"radius"])*1.25
    labels[2,"y"] = labels[2,"y"] - labels[2,"radius"]*1.25
    data = data %>%
        arrange(numbers)

    plot = ggplot() +
        geom_segment(data = triangle, aes(x=x,y=y,xend=xend,yend=yend),
                     size=1.5, color="black") +
        geom_circle(data = data,
                    aes(x0=x, y0=y, r=radius, fill=point),
                    size=0.5, color="black", fill="grey90") +
        geom_text(data = data %>% filter(numbers > 0),
                  aes(x=x,y=y,label=numbers),
                  size=7/72*25.4, fontface="plain") +
        geom_text(data = labels,
                  aes(x=x,y=y, label=name,
                      vjust=if_else(point=="point2", 0.8, 0.7)),
                  size=7/72*25.4, fontface="plain", parse=TRUE) +
        expand_limits(x = c(0, 1)) +
        coord_fixed() +
        ggtitle(title) +
        theme_void() +
        theme(plot.title=element_text(size=9, face="plain", hjust=0.5,
                                      margin = margin(t=4, b=2, unit="pt")),
              plot.margin = margin(4, 0, 0, 4, "pt"))
    return(plot)
}

main = function(theme_spec,
                common_names, cheung_path, uwimana_path, tss_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(ggforce)

    sys_to_common = read_tsv(common_names,
                             col_names=c("sys_name","common_name"))

    cheung = read_tsv(cheung_path, skip=1,
                      col_names=c("sys_ORF_name", "common_ORF_name", "probe_position",
                                  "probe_index", "avg_WT_fluorescence", "avg_spt6_fluorescence",
                                  "avg_spt6_WT_ratio", "ratio_spt6_WT_to_spt6_WT_probe1",
                                  "spt6_short_transcript"))

    uwimana = read_tsv(uwimana_path, skip=1,
                       col_names=c("sCT_ID", "chrom", "cryptic_zone_start",
                                   "cryptic_zone_end", "cryptic_TSS", "ORF_end",
                                   "transcript_end", "strand", "sys_gene_name",
                                   "sCT_spt6_FPKM", "lfc_spt6_WT", "zscore"))

    doris = read_tsv(tss_path) %>%
                inner_join(sys_to_common, by=c("orf_name"="common_name"))

    cheung_genes = cheung %>%
        filter(spt6_short_transcript=="Yes") %>%
        select(sys_ORF_name) %>%
        unique()
    uwimana_genes = uwimana %>%
        select(sys_gene_name) %>%
        unique()
    doris_genes = doris %>%
        select(sys_name) %>%
        unique()

    df = list2table3l(cheung_genes$sys_ORF_name,
                      uwimana_genes$sys_gene_name,
                      doris_genes$sys_name)

    supp_one_f = bvenn(list("\"Cheung\" ~ italic(\"et al.\")*\", 2008\""=cheung_genes$sys_ORF_name,
                           "\"Uwimana\" ~ italic(\"et al.\")*\", 2017\""=uwimana_genes$sys_gene_name,
                           "\"this work\""=doris_genes$sys_name),
                      scale=0.9, title="genes with sense intragenic transcripts")
    supp_one_f %<>% add_label("F")

    ggsave(svg_out, plot=supp_one_f, width=fig_width, height=fig_height, units="cm")
    ggsave(pdf_out, plot=supp_one_f, width=fig_width, height=fig_height, units="cm")
    ggsave(png_out, plot=supp_one_f, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(supp_one_f, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     common_names = snakemake@input[["common_names"]],
     cheung_path = snakemake@input[["cheung_data"]],
     uwimana_path = snakemake@input[["uwimana_data"]],
     tss_path = snakemake@input[["tss_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])

