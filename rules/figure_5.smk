#!/usr/bin/env python

# intragenic MNase clusters
rule figure_five_a:
    input:
        annotation = config["figure_five"]["five_a"]["annotation"],
        mnase_data = config["figure_five"]["five_a"]["mnase_data"],
        rnapii_data = config["figure_five"]["five_a"]["rnapii_data"],
        spt6_data = config["figure_five"]["five_a"]["spt6_data"],
        gc_data = config["figure_five"]["five_a"]["gc_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.svg",
        pdf = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.pdf",
        png = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.png",
        grob = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_a"]["height"])),
        width = eval(str(config["figure_five"]["five_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure5A.R"

