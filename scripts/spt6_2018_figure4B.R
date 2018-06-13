
main = function(theme_spec,
                netseq_data, mnase_data, quant_data, annotation_path,
                fig_width, fig_height,
                svg_out, pdf_out, png_out, grob_out){
    source(theme_spec)
    library(cowplot)
    library(pals)

    sample_ids = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")
    max_length = 1
    mnase_cutoff = 0.95
    netseq_cutoff = 0.93

    netseq_df = read_tsv(netseq_data,
                         col_names=c('group', 'sample', 'annotation', 'index', 'position', 'signal')) %>%
        filter(group=="WT-37C" & between(position, -0.1, 0.5)) %>%
        group_by(group, index, position) %>%
        summarise(signal = mean(signal)) %>%
        ungroup() %>%
        mutate(group = "\"WT\"")

    mnase_df = read_tsv(mnase_data,
                        col_names=c('group', 'sample', 'annotation', 'index', 'position', 'signal')) %>%
        filter(position <= max_length & sample %in% sample_ids) %>%
        group_by(group, index, position) %>%
        summarise(signal = mean(signal)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("WT-37C", "spt6-1004-37C"),
                               labels = c("\"WT\"", "italic(\"spt6-1004\")")))

    netseq_plot = ggplot(data = netseq_df %>%
                             complete(group, index, position, fill=list(signal=0)),
                         aes(x=position, y=index, fill=signal)) +
        geom_raster() +
        scale_x_continuous(breaks = c(0, 0.4),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          x==0.4 ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           expand = c(0.025, 0)) +
        scale_y_reverse(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                        name = paste(n_distinct(netseq_df[["index"]]), "nonoverlapping coding genes"),
                        expand = c(0, 50)) +
        scale_fill_viridis(option="inferno",
                           limits = c(NA, quantile(netseq_df[["signal"]], probs=netseq_cutoff)),
                           oob=scales::squish,
                           breaks = scales::pretty_breaks(n=2),
                           name = "NET-seq",
                           guide=guide_colorbar(title.position="top",
                                                title.hjust=1,
                                                barwidth=unit(1.3, "cm"),
                                                barheight=0.3)) +
        facet_grid(.~group, labeller=label_parsed) +
        theme_heatmap +
        theme(strip.text = element_text(size=9, color="black", face="plain", margin=margin(0, 0, -4, 0, "pt")),
              panel.grid.major.x = element_line(color="black"),
              panel.grid.major.y = element_line(color="black"),
              legend.box.margin = margin(0, 0, -3, 0, "pt"),
              legend.justification = c(0, 0.5),
              plot.margin = margin(4,4,-10,4,"pt" ))

    mnase_plot = ggplot(data = mnase_df %>%
                            complete(group, index, position, fill=list(signal=0)),
                        aes(x=position, y=index, fill=signal)) +
        geom_raster() +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "+1 dyad",
                                                          x==max_length ~ paste0(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           expand = c(0, 0.025)) +
        scale_y_reverse(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                        expand = c(0, 50), name=NULL) +
        scale_fill_viridis(option="inferno",
                           limits = c(NA, quantile(mnase_df[["signal"]], probs=mnase_cutoff)),
                           oob=scales::squish,
                           breaks = scales::pretty_breaks(n=3),
                           name = "MNase-seq dyad signal",
                           guide=guide_colorbar(title.position="top",
                                                barwidth=8, barheight=0.3, title.hjust=0.5)) +
        facet_grid(.~group, labeller=label_parsed) +
        theme_heatmap +
        theme(strip.text = element_text(size=9, color="black", face="plain", margin=margin(0, 0, -4, 0, "pt")),
              panel.grid.major.x = element_line(color="black"),
              panel.grid.minor.x = element_line(color="black"),
              panel.grid.major.y = element_line(color="black"),
              legend.box.margin = margin(0, 0, -3, 0, "pt"),
              plot.margin = margin(4,4,-10,0,"pt" ))

    quant_df = read_tsv(quant_data,
                        col_types = "ciicdcciiiiiiidddddddddddddddic") %>%
            left_join(read_tsv(annotation_path,
                               col_names = c('chrom', 'start', 'end', 'feat_name', 'score', 'feat_strand')) %>%
                                   select(-score) %>%
                                   mutate(annotation="nonoverlapping coding genes"),
                      by=c("feat_chrom"="chrom", "feat_name", "feat_strand", "annotation")) %>%
            mutate(feat_start=start, feat_end=end) %>%
            select(-c(start, end, nuc_chrom, overlap)) %>%
            mutate_at(vars(nuc_start, nuc_end, nuc_center, ctrl_summit_loc, cond_summit_loc, diff_summit_loc),
                      funs(if_else(feat_strand=="+", .-feat_start, feat_end-.))) %>%
            group_by(annotation) %>%
            mutate(anno_labeled = paste(n_distinct(feat_name), annotation)) %>%
            ungroup() %>% mutate(annotation=anno_labeled) %>% select(-anno_labeled) %>%
            mutate(cond_ctrl_dist = cond_summit_loc-ctrl_summit_loc,
                   annotation = fct_inorder(annotation, ordered=TRUE),
                   index = as.integer(fct_inorder(feat_name, ordered=TRUE))) %>%
            mutate(direction=factor(as.integer(sign(cond_ctrl_dist)),
                                    levels=c(-1, 0, 1),
                                    labels=c("-", "no change", "+")))

    fuzz_plot = ggplot(data = quant_df %>%
                           filter(nuc_center-50>=-400 &
                                      nuc_center+50<=1000 &
                                      nuc_center <= feat_end-feat_start) %>%
                          mutate(label = "log[2](italic(\"spt6-1004\")/WT)"),
                       aes(x=nuc_center, y=index, width=100, fill=fuzziness_lfc)) +
        geom_tile(linetype="blank") +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "+1 dyad",
                                                          x==max_length*1e3 ~ paste0(x/1e3, "kb"),
                                                          TRUE ~ as.character(x/1000))},
                           expand = c(0, 25)) +
        scale_y_reverse(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                        expand = c(0, 50), name=NULL) +
        scale_fill_gradientn(colors = coolwarm(100), limits = c(-0.7, 0.7),
                             oob=scales::squish,
                             breaks = scales::pretty_breaks(n=2),
                             name = "fuzziness",
                             guide=guide_colorbar(title.position="top",
                                                  barwidth=5, barheight=0.3, title.hjust=0.5)) +
        facet_grid(.~label, labeller = label_parsed) +
        theme_heatmap +
        theme(strip.text = element_text(size=7, color="black", face="plain", margin=margin(0,0,-4,0,"pt")),
              legend.box.margin = margin(0, 0, -3, 0, "pt"),
              plot.margin = margin(4,4,-10,0,"pt" ))

    occ_plot = ggplot(data = quant_df %>%
                          filter(nuc_center-50>=-400 &
                                     nuc_center+50<=1000 &
                                     nuc_center <= feat_end-feat_start) %>%
                          mutate(label = "log[2](italic(\"spt6-1004\")/WT)"),
                      aes(x=nuc_center, y=index, width=100, fill=summit_lfc)) +
        geom_tile(linetype="blank") +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "+1 dyad",
                                                          x==max_length*1e3 ~ paste0(x/1e3, "kb"),
                                                          TRUE ~ as.character(x/1000))},
                           expand = c(0, 25)) +
        scale_y_reverse(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                        expand = c(0, 50), name=NULL) +
        scale_fill_gradientn(colors = coolwarm(100), limits = c(-2, 2),
                             oob=scales::squish,
                             breaks = scales::pretty_breaks(n=3),
                             name = "occupancy",
                             guide=guide_colorbar(title.position="top",
                                                  barwidth=5, barheight=0.3, title.hjust=0.5)) +
        facet_grid(.~label, labeller = label_parsed) +
        theme_heatmap +
        theme(strip.text = element_text(size=7, color="black", face="plain", margin=margin(0,0,-4,0,"pt")),
              legend.box.margin = margin(0, 0, -3, 0, "pt"),
              plot.margin = margin(4,4,-10,0,"pt" ))

    fig_four_b = plot_grid(netseq_plot, mnase_plot, occ_plot, fuzz_plot, align="h", axis="tb", nrow=1,
                     rel_widths = c(0.2, 1, 0.5, 0.5)) %>%
        add_label("B")

    ggplot2::ggsave(svg_out, plot=fig_four_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(pdf_out, plot=fig_four_b, width=fig_width, height=fig_height, units="cm")
    ggplot2::ggsave(png_out, plot=fig_four_b, width=fig_width, height=fig_height, units="cm", dpi=326)
    save(fig_four_b, file=grob_out)
}

main(theme_spec = snakemake@input[["theme"]],
     netseq_data = snakemake@input[["netseq_data"]],
     mnase_data = snakemake@input[["mnase_data"]],
     quant_data = snakemake@input[["quant_data"]],
     annotation_path = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     svg_out = snakemake@output[["svg"]],
     pdf_out = snakemake@output[["pdf"]],
     png_out = snakemake@output[["png"]],
     grob_out = snakemake@output[["grob"]])
