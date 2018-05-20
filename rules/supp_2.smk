#!/usr/bin/env python

#TFIIB ChIPnexus scatterplots
rule supp_two_a:
    input:
        tfiib_data = config["figure_two"]["supp_a"]["tfiib_data"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.svg",
        pdf = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.pdf",
        png = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.png",
        grob = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_two"]["supp_a"]["height"])),
        width = eval(str(config["figure_two"]["supp_a"]["width"])),
    script:
        "../scripts/spt6_2018_supp2A.R"

