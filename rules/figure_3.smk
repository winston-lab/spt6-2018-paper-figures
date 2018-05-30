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

# NET-seq fold-change versus Spt6 ChIP-nexus levels
rule figure_three_b:
    input:
        netseq_results = config["figure_three"]["three_b"]["netseq_results"],
        annotation = config["figure_three"]["three_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure3/figure3B/spt6_2018_figure3B-NET-seq-foldchange-vs-Spt6-ChIP-nexus-levels.svg",
        pdf = "figure3/figure3B/spt6_2018_figure3B-NET-seq-foldchange-vs-Spt6-ChIP-nexus-levels.pdf",
        png = "figure3/figure3B/spt6_2018_figure3B-NET-seq-foldchange-vs-Spt6-ChIP-nexus-levels.png",
        grob = "figure3/figure3B/spt6_2018_figure3B-NET-seq-foldchange-vs-Spt6-ChIP-nexus-levels.Rdata",
    params:
        height = eval(str(config["figure_three"]["three_b"]["height"])),
        width = eval(str(config["figure_three"]["three_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure3B.R"

# antisense scatterplots vs set2
rule figure_three_c:
    input:
        data_path = config["figure_three"]["three_c"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq.svg",
        pdf = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq.pdf",
        png = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq.png",
        grob = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq.Rdata",
    params:
        height = eval(str(config["figure_three"]["three_c"]["height"])),
        width = eval(str(config["figure_three"]["three_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure3C.R"

# antisense metagenes with set2D
rule figure_three_c_alt:
    input:
        netseq_data = config["figure_three"]["three_c_alt"]["netseq_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq-metagenes.svg",
        pdf = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq-metagenes.pdf",
        png = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq-metagenes.png",
        grob = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq-metagenes.Rdata",
    params:
        height = eval(str(config["figure_three"]["three_c_alt"]["height"])),
        width = eval(str(config["figure_three"]["three_c_alt"]["width"])),
    script:
        "../scripts/spt6_2018_figure3C-alternate.R"

rule assemble_figure_three:
    input:
        three_a = "figure3/figure3A/spt6_2018_figure3A-NET-seq-average-signal.Rdata",
        three_b = "figure3/figure3B/spt6_2018_figure3B-NET-seq-foldchange-vs-Spt6-ChIP-nexus-levels.Rdata",
        three_c = "figure3/figure3C/spt6_2018_figure3C-spt6-v-set2-antisense-NET-seq-metagenes.Rdata",
    output:
        svg = "figure3/spt6_2018_figure3-NET-seq.svg",
        pdf = "figure3/spt6_2018_figure3-NET-seq.pdf",
        png = "figure3/spt6_2018_figure3-NET-seq.png",
        grob = "figure3/spt6_2018_figure3-NET-seq.Rdata",
    params:
        height = eval(str(config["figure_three"]["height"])),
        width = eval(str(config["figure_three"]["width"])),
    script:
        "../scripts/spt6_2018_figure3.R"
