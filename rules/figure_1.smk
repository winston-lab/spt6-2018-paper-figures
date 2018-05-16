#!/usr/bin/env python

#metagene of wild-type TSS-seq
rule figure_one_b:
    input:
        tss_data = config["figure_one"]["one_b"]["tss-seq_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.svg",
        pdf = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.pdf",
        png = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.png",
        grob = "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.Rdata",
    params:
        height = config["figure_one"]["one_b"]["height"],
        width = config["figure_one"]["one_b"]["width"],
    script:
        "../scripts/spt6_2018_figure1B.R"
