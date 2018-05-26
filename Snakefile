#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.png",
        "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.png",
        "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.png",
        "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.png",
        "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.png",
        "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.png",
        "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.png",
        "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.png",
        "figure2/figure2B/spt6_2018_figure2B-VAM6-ChIPnexus-and-qPCR.png",
        "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.png",
        "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.png",
        "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.png",
        "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.png",
        "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.png",
        "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.png",
        "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.png",
        "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.png",
        "figure3/figure3B/spt6_2018_figure3B-spt6-v-set2-antisense-NET-seq.png",
        "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.png",
        "figure4/figure4B/spt6_2018_figure4B-VAM6-MNase-seq-and-H3-qPCR.png",
        "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.png",
        "figure4/figure4D/spt6_2018_figure4D-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.png",
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
