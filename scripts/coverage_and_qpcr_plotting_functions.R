
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        select(-c(annotation, assay, index)) %>%
        mutate(group = ordered(group,
                               levels = c("spt6+", "spt6-1004-37C"),
                               labels = c("WT", "spt6-1004"))) %>%
        return()
}

build_qpcr_df = function(path, gene_id, norm="input"){
    df = read_tsv(path) %>%
        mutate(condition=fct_inorder(condition))
    subdf = df %>%
        filter(gene==gene_id)
    if (norm != "input"){
        subdf = df %>% filter(gene==norm) %>%
            select(condition, replicate, spikein=value) %>%
            left_join(subdf, ., by=c("condition", "replicate")) %>%
            mutate(value=value/spikein)
    }

    strand = subdf %>% distinct(strand) %>% pull(strand)
    if (strand=="+"){
        subdf %<>%
            mutate_at(vars(amplicon_start, amplicon_end, transcript_end, orf_start, orf_end, transcript_start),
                      funs((.-transcript_start))/1e3)
    } else if (strand=="-"){
        subdf %<>%
            mutate_at(vars(amplicon_start, amplicon_end, transcript_start, orf_start, orf_end, transcript_end),
                      funs((transcript_end-.)/1e3))
    }
    return(subdf)
}

plot_seq_data = function(qpcr_df, seqdata_df, title, show_y_title=TRUE, line_type="blank",
                         show_legend=TRUE, show_title=TRUE, show_amplicons=TRUE){
    seq_plot = ggplot() +
        geom_vline(data = qpcr_df %>%
                       distinct(amplicon_start, amplicon_end) %>%
                       gather(key, coord),
                   aes(xintercept = coord), linetype=if(show_amplicons){"dashed"}else{"blank"},
                   alpha=0.3, size=0.3) +
        geom_area(data = seqdata_df,
                  aes(x=position, y=signal, fill=group, color=group),
                  position=position_identity(),
                  size=0.15,
                  linetype=line_type,
                  alpha=0.75) +
        scale_x_continuous(expand=c(0,0),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==3 ~ paste0(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        # scale_y_continuous(limits = c(-1, NA),
        scale_y_continuous(limits = c(NA, max(seqdata_df[["signal"]]) *1.05),
                           expand = c(0,0),
                           labels = function(x){abs(x)},
                           name = if(show_y_title){"normalized counts"} else {NULL},
                           breaks = scales::pretty_breaks(n=2)) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        ggtitle(if(show_title){title} else {""}) +
        theme_default +
        theme(legend.position = if(show_legend){c(0.8, 0.75)} else{"none"},
              legend.justification = c(0.5, 0.5),
              axis.title.x = element_blank(),
              axis.title.y = element_text(vjust=0, margin=margin(0,0,0,0,"pt")),
              axis.text.x = element_blank(),
              panel.grid = element_blank(),
              panel.border = element_blank(),
              plot.margin = margin(-5,5,-20,0,"pt"),
              axis.line = element_line(size=0.25, color="grey65"))
    return(seq_plot)
}

plot_gene_diagram = function(qpcr_df, seqdata_df, gene_id){
    txn_end = max(c(qpcr_df[["transcript_start"]], qpcr_df[["transcript_end"]]))
    orf_start = min(c(qpcr_df[["orf_start"]], qpcr_df[["orf_end"]]))
    orf_end = max(c(qpcr_df[["orf_start"]], qpcr_df[["orf_end"]]))

    diagram = ggplot() +
        geom_vline(data = qpcr_df %>%
                       distinct(amplicon_start, amplicon_end) %>%
                       gather(key, coord),
                   aes(xintercept = coord), linetype="dashed", alpha=0.3, size=0.3) +
        annotate(geom="segment", color="black",
                 x=0, xend=txn_end, y=0, yend=0) +
        annotate(geom="polygon", fill="grey80",
                 x=c(orf_start, (orf_end-orf_start)*.95, orf_end,
                     (orf_end-orf_start)*.95, orf_start),
                 y=c(1,1,0,-1,-1)) +
        annotate(geom="text",
                 label=paste0("italic(\"", gene_id, "\")"),
                 x=(orf_start+orf_end)/2, y=0,
                 size=7/72*25.4, parse=TRUE) +
        scale_x_continuous(limits = c(min(seqdata_df[["position"]]), max(seqdata_df[["position"]])),
                           expand=c(0,0)) +
        scale_y_continuous(limits = c(-1.5, 1.5), expand=c(0,0)) +
        theme_void() +
        theme(plot.margin = margin(-10,0,0,0,"pt"))
    return(diagram)
}

plot_qpcr = function(qpcr_df, seqdata_df, title, show_y_title=TRUE,
                     show_legend=TRUE, show_title=TRUE){
    qpcr_summary = qpcr_df %>%
        group_by(amplicon_start, amplicon_end, condition) %>%
        summarise(mean = mean(value*100),
                  sd = sd(value*100))

    qpcr_plot = ggplot() +
        geom_vline(data = qpcr_summary,
                   aes(xintercept = amplicon_start), linetype="dashed", alpha=0.3, size=0.3) +
        geom_vline(data = qpcr_summary,
                   aes(xintercept = amplicon_end), linetype="dashed", alpha=0.3, size=0.3) +
        geom_col(data = qpcr_summary,
                 aes(x=(amplicon_start+amplicon_end)/2, y=mean, group=condition),
                 position=position_dodge(0.45), width=0.4, alpha=0.9, size=0.2, fill="white", color="black") +
        geom_errorbar(data = qpcr_summary,
                      aes(x=(amplicon_start+amplicon_end)/2, ymin=mean-sd, ymax=mean+sd,
                          group = interaction(amplicon_start, condition)),
                      position = position_dodge(width=0.45),
                      width=0.2, alpha=0.9) +
        # geom_boxplot(position=position_dodge(.45), width=.4, size=0.3) +
        geom_point(data = qpcr_df,
                   aes(x=(amplicon_start+amplicon_end)/2, y=value*100, color=condition),
                   position=position_jitterdodge(jitter.width=.4, dodge.width = .45),
                   # position = position_dodge(width=0.45),
                   size=0.8, alpha=0.9) +
        # scale_fill_ptol(labels=c("WT", bquote(italic("spt6-1004"))), guide=guide_legend(reverse = TRUE)) +
        scale_color_ptol(labels=c("WT", bquote(italic("spt6-1004")))) +
        scale_x_continuous(limits = c(min(seqdata_df[["position"]]), max(seqdata_df[["position"]])),
                           expand = c(0,0),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==3 ~ paste0(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        scale_y_continuous(limits = c(0, max(c(qpcr_df[["value"]], qpcr_summary[["mean"]] + qpcr_summary[["sd"]])) *1.05),
                           expand = c(0,0),
                           breaks = scales::pretty_breaks(n=2),
                           name = if(show_y_title){"enrichment (AU)"} else {NULL}) +
        ggtitle(if(show_title){title} else {""}) +
        theme_default +
        theme(legend.position = if(show_legend){c(0.8, 0.75)} else{"none"},
              legend.justification = c(0.5, 0.5),
              axis.title.x = element_blank(),
              axis.title.y = element_text(vjust=1, margin=margin(0,0,0,0,"pt")),
              panel.grid = element_blank(),
              plot.margin = margin(-5,5,0,0,"pt"))
    return(qpcr_plot)
}

plot_nexus_stranded = function(qpcr_df, plus_df, minus_df, title, show_y_title=TRUE, show_legend=TRUE, show_title=TRUE, show_amplicons=TRUE){
    seq_plot = ggplot() +
        geom_vline(data = qpcr_df %>%
                       distinct(amplicon_start, amplicon_end) %>%
                       gather(key, coord),
                   aes(xintercept = coord), linetype=if(show_amplicons){"dashed"}else{"blank"},
                   alpha=0.3, size=0.3) +
        geom_area(data = plus_df,
                  aes(x=position, y=signal, fill=group, color=group),
                  position=position_identity(),
                  size=0.15,
                  linetype="solid",
                  alpha=0.75) +
        geom_area(data = minus_df,
                  aes(x=position, y=-signal, fill=group, color=group),
                  position=position_identity(),
                  size=0.15,
                  linetype="solid",
                  alpha=0.75) +
        scale_x_continuous(expand=c(0,0),
                           labels = function(x)case_when(x==0 ~ "TSS",
                                                         x==3 ~ paste0(x, "kb"),
                                                         TRUE ~ as.character(x))) +
        # scale_y_continuous(limits = c(-1, NA),
        scale_y_continuous(labels = function(x){abs(x)},
                           name = if(show_y_title){"normalized counts"} else {NULL},
                           breaks = scales::pretty_breaks(n=3)) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        ggtitle(if(show_title){title} else {""}) +
        theme_default +
        theme(legend.position = if(show_legend){c(0.8, 0.75)} else{"none"},
              legend.justification = c(0.5, 0.5),
              axis.title.x = element_blank(),
              axis.title.y = element_text(vjust=0, margin=margin(0,0,0,0,"pt")),
              axis.text.x = element_blank(),
              panel.grid = element_blank(),
              panel.border = element_blank(),
              plot.margin = margin(-5,5,-20,0,"pt"),
              axis.line = element_line(size=0.25, color="grey65"))
    return(seq_plot)
}
