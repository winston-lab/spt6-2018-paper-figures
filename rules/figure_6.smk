#!/usr/bin/env python

localrules: assemble_figure_six

rule figure_six_a:
    input:
        theme = config["theme_spec"],
        plot_functions = "scripts/coverage_and_qpcr_plotting_functions.R",
        pma1_tfiib_nexus = config["figure_six"]["six_a"]["pma1_tfiib_nexus"],
        # pma1_tss_sense = config["figure_six"]["six_a"]["pma1_tss_sense"],
        pma1_mnase = config["figure_six"]["six_a"]["pma1_mnase"],
        hsp82_tfiib_nexus = config["figure_six"]["six_a"]["hsp82_tfiib_nexus"],
        # hsp82_tss_sense = config["figure_six"]["six_a"]["hsp82_tss_sense"],
        hsp82_mnase = config["figure_six"]["six_a"]["hsp82_mnase"],
        qpcr_data = config["figure_six"]["six_a"]["qpcr_data_path"],
    output:
        svg = "figure6/figure6A/spt6_2018_figure6A-genic-promoters-PMA1-and-HSP82.svg",
        pdf = "figure6/figure6A/spt6_2018_figure6A-genic-promoters-PMA1-and-HSP82.pdf",
        png = "figure6/figure6A/spt6_2018_figure6A-genic-promoters-PMA1-and-HSP82.png",
        grob = "figure6/figure6A/spt6_2018_figure6A-genic-promoters-PMA1-and-HSP82.Rdata",
    params:
        height = eval(str(config["figure_six"]["six_a"]["height"])),
        width = eval(str(config["figure_six"]["six_a"]["width"])),
    script:
        "../scripts/spt6_2018_figure6A.R"

rule figure_six_b:
    input:
        mnase_data = config["figure_six"]["six_b"]["mnase_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure6/figure6B/spt6_2018_figure6B-MNase-at-genic-TSSs.svg",
        pdf = "figure6/figure6B/spt6_2018_figure6B-MNase-at-genic-TSSs.pdf",
        png = "figure6/figure6B/spt6_2018_figure6B-MNase-at-genic-TSSs.png",
        grob = "figure6/figure6B/spt6_2018_figure6B-MNase-at-genic-TSSs.Rdata",
    params:
        height = eval(str(config["figure_six"]["six_b"]["height"])),
        width = eval(str(config["figure_six"]["six_b"]["width"])),
    script:
        "../scripts/spt6_2018_figure6B.R"

# rule figure_six_c:
#     input:
#         go_results = config["figure_six"]["six_c"]["go_results"],
#         theme = config["theme_spec"]
#     output:
#         svg = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.svg",
#         pdf = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.pdf",
#         png = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.png",
#         grob = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.Rdata",
#     params:
#         height = eval(str(config["figure_six"]["six_c"]["height"])),
#         width = eval(str(config["figure_six"]["six_c"]["width"])),
#     script:
#         "../scripts/spt6_2018_figure6C.R"

rule figure_six_c:
    input:
        data_path = config["figure_six"]["six_c"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure6/figure6C/spt6_2018_figure6C-spt6-depletion-RTqPCR.svg",
        pdf = "figure6/figure6C/spt6_2018_figure6C-spt6-depletion-RTqPCR.pdf",
        png = "figure6/figure6C/spt6_2018_figure6C-spt6-depletion-RTqPCR.png",
        grob = "figure6/figure6C/spt6_2018_figure6C-spt6-depletion-RTqPCR.Rdata",
    params:
        height = eval(str(config["figure_six"]["six_c"]["height"])),
        width = eval(str(config["figure_six"]["six_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure6C.R"

rule assemble_figure_six:
    input:
        six_a = "figure6/figure6A/spt6_2018_figure6A-genic-promoters-PMA1-and-HSP82.Rdata",
        six_b = "figure6/figure6B/spt6_2018_figure6B-MNase-at-genic-TSSs.Rdata",
        six_c = "figure6/figure6C/spt6_2018_figure6C-spt6-depletion-RTqPCR.Rdata",
    output:
        svg = "figure6/spt6_2018_figure6-genic-promoters.svg",
        pdf = "figure6/spt6_2018_figure6-genic-promoters.pdf",
        png = "figure6/spt6_2018_figure6-genic-promoters.png",
        grob = "figure6/spt6_2018_figure6-genic-promoters.Rdata",
    params:
        height = eval(str(config["figure_six"]["height"])),
        width = eval(str(config["figure_six"]["width"])),
    script:
        "../scripts/spt6_2018_figure6.R"

