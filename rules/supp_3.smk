#!/usr/bin/env python

localrules: assemble_supp_three

#NETseq scatterplots
rule supp_three_a:
    input:
        netseq_data = config["figure_three"]["supp_a"]["netseq_data"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.svg",
        pdf = "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.pdf",
        png = "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.png",
        grob = "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_three"]["supp_a"]["height"])),
        width = eval(str(config["figure_three"]["supp_a"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp3A.R"

#NETseq scatterplots
rule supp_three_b:
    input:
        sense_netseq_data = config["figure_three"]["supp_b"]["sense_netseq_data"],
        antisense_netseq_data = config["figure_three"]["supp_b"]["antisense_netseq_data"],
        annotation = config["figure_three"]["supp_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure3/supp3B/spt6_2018_supp3B-NETseq-foldchange-heatmaps.svg",
        pdf = "figure3/supp3B/spt6_2018_supp3B-NETseq-foldchange-heatmaps.pdf",
        png = "figure3/supp3B/spt6_2018_supp3B-NETseq-foldchange-heatmaps.png",
        grob = "figure3/supp3B/spt6_2018_supp3B-NETseq-foldchange-heatmaps.Rdata",
    params:
        height = eval(str(config["figure_three"]["supp_b"]["height"])),
        width = eval(str(config["figure_three"]["supp_b"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp3B.R"

# RNAPII and Spt6 ChIP-nexus scatterplots
rule supp_three_c:
    input:
        data_path = config["figure_three"]["supp_c"]["data_path"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure3/supp3C/spt6_2018_supp3C-RNAPII-and-Spt6-ChIP-nexus-scatterplots.svg",
        pdf = "figure3/supp3C/spt6_2018_supp3C-RNAPII-and-Spt6-ChIP-nexus-scatterplots.pdf",
        png = "figure3/supp3C/spt6_2018_supp3C-RNAPII-and-Spt6-ChIP-nexus-scatterplots.png",
        grob = "figure3/supp3C/spt6_2018_supp3C-RNAPII-and-Spt6-ChIP-nexus-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_three"]["supp_c"]["height"])),
        width = eval(str(config["figure_three"]["supp_c"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp3C.R"

rule assemble_supp_three:
    input:
        three_a = "figure3/supp3A/spt6_2018_supp3A-NETseq-scatterplots.Rdata",
        three_b = "figure3/supp3B/spt6_2018_supp3B-NETseq-foldchange-heatmaps.Rdata",
        three_c = "figure3/supp3C/spt6_2018_supp3C-RNAPII-and-Spt6-ChIP-nexus-scatterplots.Rdata",
    output:
        svg = "figure3/spt6_2018_supp3-NET-seq.svg",
        pdf = "figure3/spt6_2018_supp3-NET-seq.pdf",
        png = "figure3/spt6_2018_supp3-NET-seq.png",
        grob = "figure3/spt6_2018_supp3-NET-seq.Rdata",
    params:
        height = eval(str(config["figure_three"]["supp_height"])),
        width = eval(str(config["figure_three"]["supp_width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp3.R"

