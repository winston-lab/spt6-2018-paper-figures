#!/usr/bin/env python

localrules:

# intragenic motif enrichment
rule supp_five_a:
    input:
        all_motif_path = config["figure_five"]["supp_a"]["all_motif_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/spt6_2018_supp5-intragenic-promoters.svg",
        pdf = "figure5/spt6_2018_supp5-intragenic-promoters.pdf",
        png = "figure5/spt6_2018_supp5-intragenic-promoters.png",
        grob = "figure5/spt6_2018_supp5-intragenic-promoters.Rdata",
    params:
        height = eval(str(config["figure_five"]["supp_a"]["height"])),
        width = eval(str(config["figure_five"]["supp_a"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp5A.R"

# rule assemble_figure_five:
#     input:
#         five_a = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.Rdata",
#         five_b = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.Rdata",
#         five_c = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.Rdata",
#         five_d = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-TATA-boxes.Rdata",
#         five_e = "figure5/figure5E/spt6_2018_figure5E-intragenic-TSS-motif-enrichment.Rdata",
#     output:
#         svg = "figure5/spt6_2018_figure5-intragenic-promoters.svg",
#         pdf = "figure5/spt6_2018_figure5-intragenic-promoters.pdf",
#         png = "figure5/spt6_2018_figure5-intragenic-promoters.png",
#         grob = "figure5/spt6_2018_figure5-intragenic-promoters.Rdata",
#     params:
#         height = eval(str(config["figure_five"]["height"])),
#         width = eval(str(config["figure_five"]["width"])),
#     conda: "../envs/plot.yaml"
#     script:
#         "../scripts/spt6_2018_figure5.R"

