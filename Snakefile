#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.png",
        "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.png",
        "figure1/figure1E/spt6_2018_figure1E-TSS-seq-diffexp-summary.png",
        "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.png",
        "figure2/figure2A/spt6_2018_figure2A-NET-seq-average-signal.png",
        "figure2/figure2B/spt6_2018_figure2B-MNase-seq-average-signal.png",
        "figure2/figure2C/spt6_2018_figure2C-Mnase-global-quantification.png",
        "figure6/figure6A/spt6_2018_figure6A-Mnase-at-genic-TSSs.png",
        "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.png",

include: "rules/figure_1.smk"
include: "rules/supp_1.smk"
include: "rules/figure_2.smk"
include: "rules/figure_6.smk"
