#!/usr/bin/env python

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
    script:
        "../scripts/spt6_2018_supp3A.R"

