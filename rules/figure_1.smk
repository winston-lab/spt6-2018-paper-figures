#!/usr/bin/env python

# heatmaps of TSS-seq signal
rule figure_one_c:
    input:
        sense_tss_data = config["figure_one"]["one_c"]["sense_tss_data"],
        antisense_tss_data = config["figure_one"]["one_c"]["antisense_tss_data"],
        annotation = config["figure_one"]["one_c"]["annotation"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.svg",
        pdf = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.pdf",
        png = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.png",
        grob = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_c"]["height"])),
        width = eval(str(config["figure_one"]["one_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure1C.R"

# mosaic plot of TSS-seq differential expression
rule figure_one_e:
    input:
        in_genic = config["figure_one"]["one_e"]["genic"],
        in_intra = config["figure_one"]["one_e"]["intragenic"],
        in_anti = config["figure_one"]["one_e"]["antisense"],
        in_inter = config["figure_one"]["one_e"]["intergenic"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-diffexp-summary.svg",
        pdf = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-diffexp-summary.pdf",
        png = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-diffexp-summary.png",
        grob = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-diffexp-summary.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_e"]["height"])),
        width = eval(str(config["figure_one"]["one_e"]["width"])),
    script:
        "../scripts/spt6_2018_figure1E.R"

