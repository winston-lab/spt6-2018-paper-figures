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

# intragenic MNase clusters expression level
rule figure_five_b:
    input:
        cluster_one = config["figure_five"]["five_b"]["cluster_one"],
        cluster_two = config["figure_five"]["five_b"]["cluster_two"],
        tss_diffexp = config["figure_five"]["five_b"]["tss_diffexp"],
        tfiib_diffbind = config["figure_five"]["five_b"]["tfiib_diffbind"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.svg",
        pdf = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.pdf",
        png = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.png",
        grob = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_b"]["height"])),
        width = eval(str(config["figure_five"]["five_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure5B.R"

# intragenic TSSs sequence logos
rule figure_five_c:
    input:
        data_paths = config["figure_five"]["five_c"]["data_paths"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.svg",
        pdf = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.pdf",
        png = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.png",
        grob = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_c"]["height"])),
        width = eval(str(config["figure_five"]["five_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure5C.R"

