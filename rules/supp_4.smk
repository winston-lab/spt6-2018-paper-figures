#!/usr/bin/env python

#MNase-seq scatterplots
rule supp_four_a:
    input:
        mnase_data = config["figure_four"]["supp_a"]["mnase_data"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.svg",
        pdf = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.pdf",
        png = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.png",
        grob = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_four"]["supp_a"]["height"])),
        width = eval(str(config["figure_four"]["supp_a"]["width"])),
    script:
        "../scripts/spt6_2018_supp4A.R"

#MNase-seq scatterplots
rule supp_four_b:
    input:
        mnase_data = config["figure_four"]["supp_b"]["mnase_data"],
        annotation = config["figure_four"]["supp_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.svg",
        pdf = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.pdf",
        png = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.png",
        grob = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.Rdata",
    params:
        height = eval(str(config["figure_four"]["supp_b"]["height"])),
        width = eval(str(config["figure_four"]["supp_b"]["width"])),
    script:
        "../scripts/spt6_2018_supp4B.R"

rule assemble_supp_four:
    input:
        four_a = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.Rdata",
        four_b = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.Rdata",
    output:
        svg = "figure4/spt6_2018_supp4-MNase-seq.svg",
        pdf = "figure4/spt6_2018_supp4-MNase-seq.pdf",
        png = "figure4/spt6_2018_supp4-MNase-seq.png",
        grob = "figure4/spt6_2018_supp4-MNase-seq.Rdata",
    params:
        height = eval(str(config["figure_four"]["supp_height"])),
        width = eval(str(config["figure_four"]["supp_width"])),
    script:
        "../scripts/spt6_2018_supp4.R"

