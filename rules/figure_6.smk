#!/usr/bin/env python

rule figure_six_a:
    input:
        pma_seq_data = config["figure_six"]["six_a"]["pma_seq_data"],
        hsp_seq_data = config["figure_six"]["six_a"]["hsp_seq_data"],
        qpcr_data = config["figure_six"]["six_a"]["qpcr_data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure6/figure6A/spt6_2018_figure6A-TFIIB-at-PMA1-and-HSP82.svg",
        pdf = "figure6/figure6A/spt6_2018_figure6A-TFIIB-at-PMA1-and-HSP82.pdf",
        png = "figure6/figure6A/spt6_2018_figure6A-TFIIB-at-PMA1-and-HSP82.png",
        grob = "figure6/figure6A/spt6_2018_figure6A-TFIIB-at-PMA1-and-HSP82.Rdata",
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

rule figure_six_c:
    input:
        go_results = config["figure_six"]["six_c"]["go_results"],
        theme = config["theme_spec"]
    output:
        svg = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.svg",
        pdf = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.pdf",
        png = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.png",
        grob = "figure6/figure6C/spt6_2018_figure6C-spt6-upregulated-genic-TSSs-gene-ontology.Rdata",
    params:
        height = eval(str(config["figure_six"]["six_c"]["height"])),
        width = eval(str(config["figure_six"]["six_c"]["width"])),
    script:
        "../scripts/spt6_2018_figure6C.R"

rule figure_six_d:
    input:
        data_path = config["figure_six"]["six_d"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure6/figure6D/spt6_2018_figure6D-spt6-depletion-SSA4-RTqPCR.svg",
        pdf = "figure6/figure6D/spt6_2018_figure6D-spt6-depletion-SSA4-RTqPCR.pdf",
        png = "figure6/figure6D/spt6_2018_figure6D-spt6-depletion-SSA4-RTqPCR.png",
        grob = "figure6/figure6D/spt6_2018_figure6D-spt6-depletion-SSA4-RTqPCR.Rdata",
    params:
        height = eval(str(config["figure_six"]["six_d"]["height"])),
        width = eval(str(config["figure_six"]["six_d"]["width"])),
    script:
        "../scripts/spt6_2018_figure6D.R"


