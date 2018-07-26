#!/usr/bin/env python

localrules: assemble_figure_five

# intragenic MNase clusters
rule figure_five_a:
    input:
        annotation = config["figure_five"]["five_a"]["annotation"],
        mnase_data = config["figure_five"]["five_a"]["mnase_data"],
        # rnapii_data = config["figure_five"]["five_a"]["rnapii_data"],
        # spt6_data = config["figure_five"]["five_a"]["spt6_data"],
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
    conda: "../envs/plot.yaml"
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
    conda: "../envs/plot.yaml"
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
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_figure5C.R"

# intragenic TATA boxes
rule figure_five_d:
    input:
        tata_genic_path = config["figure_five"]["five_d"]["tata_genic"],
        tata_intra_path = config["figure_five"]["five_d"]["tata_intragenic"],
        tata_random_path = config["figure_five"]["five_d"]["tata_random"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-TATA-boxes.svg",
        pdf = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-TATA-boxes.pdf",
        png = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-TATA-boxes.png",
        grob = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-TATA-boxes.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_d"]["height"])),
        width = eval(str(config["figure_five"]["five_d"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_figure5D.R"

rule figure_five_d_extra:
    input:
        fimo_results = config["figure_five"]["five_d_extra"]["fimo_results"],
        tss_results = config["figure_five"]["five_d_extra"]["tss_results"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5Dextra/spt6_2018_figure5Dextra-intragenic-TSS-TATA-box-expression.svg",
        pdf = "figure5/figure5Dextra/spt6_2018_figure5Dextra-intragenic-TSS-TATA-box-expression.pdf",
        png = "figure5/figure5Dextra/spt6_2018_figure5Dextra-intragenic-TSS-TATA-box-expression.png",
        grob = "figure5/figure5Dextra/spt6_2018_figure5Dextra-intragenic-TSS-TATA-box-expression.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_d_extra"]["height"])),
        width = eval(str(config["figure_five"]["five_d_extra"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_figure5Dextra.R"

# intragenic motif enrichment
rule figure_five_e:
    input:
        all_motif_path = config["figure_five"]["five_e"]["all_motif_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5E/spt6_2018_figure5E-intragenic-TSS-motif-enrichment.svg",
        pdf = "figure5/figure5E/spt6_2018_figure5E-intragenic-TSS-motif-enrichment.pdf",
        png = "figure5/figure5E/spt6_2018_figure5E-intragenic-TSS-motif-enrichment.png",
        grob = "figure5/figure5E/spt6_2018_figure5E-intragenic-TSS-motif-enrichment.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_e"]["height"])),
        width = eval(str(config["figure_five"]["five_e"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_figure5E.R"

rule assemble_figure_five:
    input:
        five_a = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.Rdata",
        five_b = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.Rdata",
        five_c = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.Rdata",
        five_d = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-TATA-boxes.Rdata",
        five_e = "figure5/figure5E/spt6_2018_figure5E-intragenic-TSS-motif-enrichment.Rdata",
    output:
        svg = "figure5/spt6_2018_figure5-intragenic-promoters.svg",
        pdf = "figure5/spt6_2018_figure5-intragenic-promoters.pdf",
        png = "figure5/spt6_2018_figure5-intragenic-promoters.png",
        grob = "figure5/spt6_2018_figure5-intragenic-promoters.Rdata",
    params:
        height = eval(str(config["figure_five"]["height"])),
        width = eval(str(config["figure_five"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_figure5.R"

