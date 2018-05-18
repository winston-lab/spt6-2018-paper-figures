#!/usr/bin/env python

#metagene of NET-seq
rule figure_two_a:
    input:
        sense_netseq_data = config["figure_two"]["two_a"]["sense_netseq_data"],
        antisense_netseq_data = config["figure_two"]["two_a"]["antisense_netseq_data"],
        annotation = config["figure_two"]["two_a"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2A/spt6_2018_figure2A-NET-seq-average-signal.svg",
        pdf = "figure2/figure2A/spt6_2018_figure2A-NET-seq-average-signal.pdf",
        png = "figure2/figure2A/spt6_2018_figure2A-NET-seq-average-signal.png",
        grob = "figure2/figure2A/spt6_2018_figure2A-NET-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_a"]["height"])),
        width = eval(str(config["figure_two"]["two_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure2A.R"

#metagene of MNase-seq
rule figure_two_b:
    input:
        mnase_data = config["figure_two"]["two_b"]["mnase_data"],
        annotation = config["figure_two"]["two_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2B/spt6_2018_figure2B-MNase-seq-average-signal.svg",
        pdf = "figure2/figure2B/spt6_2018_figure2B-MNase-seq-average-signal.pdf",
        png = "figure2/figure2B/spt6_2018_figure2B-MNase-seq-average-signal.png",
        grob = "figure2/figure2B/spt6_2018_figure2B-MNase-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_b"]["height"])),
        width = eval(str(config["figure_two"]["two_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure2B.R"

rule figure_two_c:
    input:
        wt_mnase_quant = config["figure_two"]["two_c"]["wt_mnase_quant"],
        spt6_mnase_quant = config["figure_two"]["two_c"]["spt6_mnase_quant"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/figure2C/spt6_2018_figure2C-Mnase-global-quantification.svg",
        pdf = "figure2/figure2C/spt6_2018_figure2C-Mnase-global-quantification.pdf",
        png = "figure2/figure2C/spt6_2018_figure2C-Mnase-global-quantification.png",
        grob = "figure2/figure2C/spt6_2018_figure2C-Mnase-global-quantification.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_c"]["height"])),
        width = eval(str(config["figure_two"]["two_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure2C.R"


