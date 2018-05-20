#!/usr/bin/env python

rule figure_six_a:
    input:
        mnase_data = config["figure_six"]["six_a"]["mnase_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure6/figure6A/spt6_2018_figure6A-MNase-at-genic-TSSs.svg",
        pdf = "figure6/figure6A/spt6_2018_figure6A-MNase-at-genic-TSSs.pdf",
        png = "figure6/figure6A/spt6_2018_figure6A-MNase-at-genic-TSSs.png",
        grob = "figure6/figure6A/spt6_2018_figure6A-MNase-at-genic-TSSs.Rdata",
    params:
        height = eval(str(config["figure_six"]["six_a"]["height"])),
        width = eval(str(config["figure_six"]["six_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure6A.R"


