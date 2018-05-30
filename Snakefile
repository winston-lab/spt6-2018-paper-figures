#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.png",
        "figure1/figure1B/spt6_2018_figure1B-SPT6-western-blot.png",
        "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.png",
        "figure1/spt6_2018_figure1-TSS-seq.png",
        "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.png",
        "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.png",
        "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.png",
        "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.png",
        "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.png",
        "figure1/spt6_2018_supp1-TSS-seq.png",
        "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.png",
        "figure2/figure2B/spt6_2018_figure2B-VAM6-TFIIB-ChIPnexus-and-qPCR.png",
        "figure2/figure2C/spt6_2018_figure2C-SSA4-TFIIB-ChIP-nexus.png",
        "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.png",
        "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.png",
        "figure2/spt6_2018_figure2-TFIIB-ChIP-nexus.png",
        "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.png",
        "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.png",
        "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.png",
        "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.png",
        "figure2/spt6_2018_supp2-TFIIB-ChIP-nexus.png",
        "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.png",
        "figure3/figure3B/spt6_2018_figure3B-NET-seq-foldchange-vs-Spt6-ChIP-nexus-levels.png",
        "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq.png",
        "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq-metagenes.png",
        "figure3/spt6_2018_figure3-NET-seq.png",
        "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.png",
        "figure3/supp3B/spt6_2018_supp3B-NETseq-foldchange-heatmaps.png",
        "figure3/supp3C/spt6_2018_supp3C-RNAPII-and-Spt6-ChIP-nexus-scatterplots.png",
        "figure3/spt6_2018_supp3-NET-seq.png",
        "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.png",
        "figure4/figure4B/spt6_2018_figure4B-VAM6-MNase-seq-and-H3-qPCR.png",
        "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.png",
        "figure4/figure4D/spt6_2018_figure4D-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.png",
        "figure4/spt6_2018_figure4-MNase-seq.png",
        "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.png",
        "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.png",
        "figure4/spt6_2018_supp4-MNase-seq.png",
        "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.png",
        "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.png",
        "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.png",
        "figure5/spt6_2018_figure5-intragenic-promoters.png",
        "figure6/figure6B/spt6_2018_figure6B-MNase-at-genic-TSSs.png",
        "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.png",
        "figure6/figure6D/spt6_2018_figure6D-spt6-depletion-SSA4-RTqPCR.png",

include: "rules/figure_1.smk"
include: "rules/supp_1.smk"
include: "rules/figure_2.smk"
include: "rules/supp_2.smk"
include: "rules/figure_3.smk"
include: "rules/supp_3.smk"
include: "rules/figure_4.smk"
include: "rules/supp_4.smk"
include: "rules/figure_5.smk"
include: "rules/figure_6.smk"
