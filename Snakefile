#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.png",
        "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.png",
        "figure1/figure1E/spt6_2018_figure1E-TSS-seq-diffexp-summary.png",
        "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.png",
        "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.png",
        "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.png",
        "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.png",
        "figure2/figure2B/spt6_2018_figure2B-TFIIB-ChIPnexus-VAM6-ChIPnexus-and-qPCR.png",
        "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.png",
        "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.png",
        "figure2/supp2B/spt6_2018_supp2B-TFIIB-western.png",
        "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.png",
        "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.png",
        "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.png",
        "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.png",
        "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.png",
        "figure6/figure6A/spt6_2018_figure6A-MNase-at-genic-TSSs.png",

include: "rules/figure_1.smk"
include: "rules/supp_1.smk"
include: "rules/figure_2.smk"
include: "rules/supp_2.smk"
include: "rules/figure_3.smk"
include: "rules/supp_3.smk"
include: "rules/figure_4.smk"
include: "rules/supp_4.smk"
include: "rules/figure_6.smk"
