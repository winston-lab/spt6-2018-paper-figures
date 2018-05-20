#!/usr/bin/env python

#metagene of MNase-seq
rule figure_four_a:
    input:
        mnase_data = config["figure_four"]["four_a"]["mnase_data"],
        annotation = config["figure_four"]["four_a"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.svg",
        pdf = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.pdf",
        png = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.png",
        grob = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_a"]["height"])),
        width = eval(str(config["figure_four"]["four_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure4A.R"

rule figure_four_c:
    input:
        wt_mnase_quant = config["figure_four"]["four_c"]["wt_mnase_quant"],
        spt6_mnase_quant = config["figure_four"]["four_c"]["spt6_mnase_quant"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.svg",
        pdf = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.pdf",
        png = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.png",
        grob = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_c"]["height"])),
        width = eval(str(config["figure_four"]["four_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure4C.R"


