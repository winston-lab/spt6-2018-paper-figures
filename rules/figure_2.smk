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
        svg = "figure2/figure2B/spt6_2018_figure2B-NET-seq-average-signal.svg",
        pdf = "figure2/figure2B/spt6_2018_figure2B-NET-seq-average-signal.pdf",
        png = "figure2/figure2B/spt6_2018_figure2B-NET-seq-average-signal.png",
        grob = "figure2/figure2B/spt6_2018_figure2B-NET-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_two"]["two_b"]["height"])),
        width = eval(str(config["figure_two"]["two_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure2B.R"

