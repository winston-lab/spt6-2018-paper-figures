#!/usr/bin/env python

#metagene of wild-type TSS-seq
rule figure_one_b:
    input:
        tss_data = config["figure_one"]["one_b"]["tss_data"],
        theme = config["theme_spec"],
    output:
        svg = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.svg",
        pdf = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.pdf",
        png = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.png",
        grob = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_b"]["height"])),
        width = eval(str(config["figure_one"]["one_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure1B.R"

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
        diffexp_data = config["figure_one"]["one_e"]["diffexp_data"],
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

