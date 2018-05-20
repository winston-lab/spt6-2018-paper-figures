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

