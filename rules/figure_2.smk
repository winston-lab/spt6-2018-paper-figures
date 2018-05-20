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

