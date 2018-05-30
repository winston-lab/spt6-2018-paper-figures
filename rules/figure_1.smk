#!/usr/bin/env python

# heatmaps of TSS-seq signal
rule figure_one_a:
    input:
        sense_tss_data = config["figure_one"]["one_a"]["sense_tss_data"],
        antisense_tss_data = config["figure_one"]["one_a"]["antisense_tss_data"],
        annotation = config["figure_one"]["one_a"]["annotation"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.svg",
        pdf = "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.pdf",
        png = "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.png",
        grob = "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_a"]["height"])),
        width = eval(str(config["figure_one"]["one_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure1A.R"

# Spt6 western blot
rule figure_one_b:
    input:
        data_path = config["figure_one"]["one_b"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1B/spt6_2018_figure1B-SPT6-western-blot.svg",
        pdf = "figure1/figure1B/spt6_2018_figure1B-SPT6-western-blot.pdf",
        png = "figure1/figure1B/spt6_2018_figure1B-SPT6-western-blot.png",
        grob = "figure1/figure1B/spt6_2018_figure1B-SPT6-western-blot.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_b"]["height"])),
        width = eval(str(config["figure_one"]["one_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure1B.R"

# mosaic plot of TSS-seq differential expression
rule figure_one_c:
    input:
        in_genic = config["figure_one"]["one_c"]["genic"],
        in_intra = config["figure_one"]["one_c"]["intragenic"],
        in_anti = config["figure_one"]["one_c"]["antisense"],
        in_inter = config["figure_one"]["one_c"]["intergenic"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.svg",
        pdf = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.pdf",
        png = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.png",
        grob = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_c"]["height"])),
        width = eval(str(config["figure_one"]["one_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure1C.R"

#violin plots of expression level
rule figure_one_e:
    input:
        tss_genic = config["figure_one"]["one_e"]["tss_genic"],
        tss_intragenic = config["figure_one"]["one_e"]["tss_intragenic"],
        tss_antisense = config["figure_one"]["one_e"]["tss_antisense"],
        tss_intergenic = config["figure_one"]["one_e"]["tss_intergenic"],
        # tfiib_genic = config["figure_one"]["one_e"]["tfiib_genic"],
        # tfiib_intragenic = config["figure_one"]["one_e"]["tfiib_intragenic"],
        # tfiib_intergenic = config["figure_one"]["one_e"]["tfiib_intergenic"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-expression-levels.svg",
        pdf = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-expression-levels.pdf",
        png = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-expression-levels.png",
        grob = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-expression-levels.Rdata",
    params:
        height = eval(str(config["figure_one"]["one_e"]["height"])),
        width = eval(str(config["figure_one"]["one_e"]["width"])),
    script:
        "../scripts/spt6_2018_figure1E.R"


rule assemble_figure_one:
    input:
        one_a = "figure1/figure1A/spt6_2018_figure1A-TSS-seq-heatmaps.Rdata",
        one_b = "figure1/figure1B/spt6_2018_figure1B-SPT6-western-blot.Rdata",
        one_c = "figure1/figure1C/spt6_2018_figure1C-TSS-seq-diffexp-summary.Rdata",
        one_e = "figure1/figure1E/spt6_2018_figure1E-TSS-seq-expression-levels.Rdata",
    output:
        svg = "figure1/spt6_2018_figure1-TSS-seq.svg",
        pdf = "figure1/spt6_2018_figure1-TSS-seq.pdf",
        png = "figure1/spt6_2018_figure1-TSS-seq.png",
        grob = "figure1/spt6_2018_figure1-TSS-seq.Rdata",
    params:
        height = eval(str(config["figure_one"]["height"])),
        width = eval(str(config["figure_one"]["width"])),
    script:
        "../scripts/spt6_2018_figure1.R"
