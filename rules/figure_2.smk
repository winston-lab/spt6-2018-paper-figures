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

#violin plots of expression level and TFIIB signal
rule figure_two_e:
    input:
        tss_genic = config["figure_two"]["two_e"]["tss_genic"],
        tss_intragenic = config["figure_two"]["two_e"]["tss_intragenic"],
        tss_antisense = config["figure_two"]["two_e"]["tss_antisense"],
        tss_intergenic = config["figure_two"]["two_e"]["tss_intergenic"],
        tfiib_genic = config["figure_two"]["two_e"]["tfiib_genic"],
        tfiib_intragenic = config["figure_two"]["two_e"]["tfiib_intragenic"],
        tfiib_intergenic = config["figure_two"]["two_e"]["tfiib_intergenic"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.svg",
        pdf = "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.pdf",
        png = "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.png",
        grob = "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_e"]["height"])),
        width = eval(str(config["figure_two"]["two_e"]["width"])),
    script:
        "../scripts/spt6_2018_figure2E.R"

rule assemble_figure_two:
    input:
        two_a = "figure2/figure2A/spt6_2018_figure2A-TFIIB-ChIPnexus-heatmaps.Rdata",
        two_b = "figure2/figure2B/spt6_2018_figure2B-VAM6-ChIPnexus-and-qPCR.Rdata",
        two_d = "figure2/figure2D/spt6_2018_figure2D-TSS-seq-v-TFIIB-ChIPnexus-foldchange.Rdata",
        two_e = "figure2/figure2E/spt6_2018_figure2E-TSS-seq-and-TFIIB-levels.Rdata",
    output:
        svg = "figure2/spt6_2018_figure2-TFIIB-ChIP-nexus.svg",
        pdf = "figure2/spt6_2018_figure2-TFIIB-ChIP-nexus.pdf",
        png = "figure2/spt6_2018_figure2-TFIIB-ChIP-nexus.png",
        grob = "figure2/spt6_2018_figure2-TFIIB-ChIP-nexus.Rdata",
    params:
        height = eval(str(config["figure_two"]["height"])),
        width = eval(str(config["figure_two"]["width"])),
    script:
        "../scripts/spt6_2018_figure2.R"
