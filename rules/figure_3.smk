#!/usr/bin/env python

#metagene of NET-seq
rule figure_three_a:
    input:
        sense_netseq_data = config["figure_three"]["three_a"]["sense_netseq_data"],
        antisense_netseq_data = config["figure_three"]["three_a"]["antisense_netseq_data"],
        annotation = config["figure_three"]["three_a"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.svg",
        pdf = "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.pdf",
        png = "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.png",
        grob = "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_three"]["three_a"]["height"])),
        width = eval(str(config["figure_three"]["three_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure3A.R"

# antisense scatterplots vs set2
rule figure_three_b:
    input:
        data_path = config["figure_three"]["three_b"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure3/figure3B/spt6_2018_figure3B-spt6-v-set2-antisense-NET-seq.svg",
        pdf = "figure3/figure3B/spt6_2018_figure3B-spt6-v-set2-antisense-NET-seq.pdf",
        png = "figure3/figure3B/spt6_2018_figure3B-spt6-v-set2-antisense-NET-seq.png",
        grob = "figure3/figure3B/spt6_2018_figure3B-spt6-v-set2-antisense-NET-seq.Rdata",
    params:
        height = eval(str(config["figure_three"]["three_b"]["height"])),
        width = eval(str(config["figure_three"]["three_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure3B.R"

