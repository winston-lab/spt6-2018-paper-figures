#!/usr/bin/env python

# heatmaps of TFIIB ChIP-nexus signal
rule figure_two_a:
    input:
        tfiib_data = config["figure_two"]["two_a"]["tfiib_data"],
        annotation = config["figure_two"]["two_a"]["annotation"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.svg",
        pdf = "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.pdf",
        png = "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.png",
        grob = "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_a"]["height"])),
        width = eval(str(config["figure_two"]["two_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure2A.R"

#TFIIB browser view and ChIP-qPCR
rule figure_two_b:
    input:
        seq_data = config["figure_two"]["two_b"]["seq_data"],
        qpcr_data = config["figure_two"]["two_b"]["qpcr_data"],
        annotation = config["figure_two"]["two_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2B/spt6_2018_figure2B--VAM6-ChIPnexus-and-qPCR.svg",
        pdf = "figure2/figure2B/spt6_2018_figure2B-VAM6-ChIPnexus-and-qPCR.pdf",
        png = "figure2/figure2B/spt6_2018_figure2B-VAM6-ChIPnexus-and-qPCR.png",
        grob = "figure2/figure2B/spt6_2018_figure2B-VAM6-ChIPnexus-and-qPCR.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_b"]["height"])),
        width = eval(str(config["figure_two"]["two_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure2B.R"

# TSS-seq vs TFIIB fold-change
rule figure_two_d:
    input:
        genic = config["figure_two"]["two_d"]["genic"],
        intragenic = config["figure_two"]["two_d"]["intragenic"],
        antisense = config["figure_two"]["two_d"]["antisense"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.svg",
        pdf = "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.pdf",
        png = "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.png",
        grob = "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_d"]["height"])),
        width = eval(str(config["figure_two"]["two_d"]["width"])),
    script:
        "../scripts/spt6_2018_figure2D.R"

