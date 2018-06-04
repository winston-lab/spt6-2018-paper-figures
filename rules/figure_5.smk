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

# intragenic motifs
rule figure_five_d:
    input:
        tata_genic_path = config["figure_five"]["five_d"]["tata_genic"],
        tata_intra_path = config["figure_five"]["five_d"]["tata_intragenic"],
        tata_random_path = config["figure_five"]["five_d"]["tata_random"],
        all_motif_path = config["figure_five"]["five_d"]["all_motif_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-motifs.svg",
        pdf = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-motifs.pdf",
        png = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-motifs.png",
        grob = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-motifs.Rdata",
    params:
        height = eval(str(config["figure_five"]["five_d"]["height"])),
        width = eval(str(config["figure_five"]["five_d"]["width"])),
    script:
        "../scripts/spt6_2018_figure5D.R"

rule assemble_figure_five:
    input:
        five_a = "figure5/figure5A/spt6_2018_figure5A-intragenic-TSS-MNase-clusters.Rdata",
        five_b = "figure5/figure5B/spt6_2018_figure5B-intragenic-TSS-MNase-clusters-expression.Rdata",
        five_c = "figure5/figure5C/spt6_2018_figure5C-intragenic-TSS-sequence-information.Rdata",
        five_d = "figure5/figure5D/spt6_2018_figure5D-intragenic-TSS-motifs.Rdata",
    output:
        svg = "figure5/spt6_2018_figure5-intragenic-promoters.svg",
        pdf = "figure5/spt6_2018_figure5-intragenic-promoters.pdf",
        png = "figure5/spt6_2018_figure5-intragenic-promoters.png",
        grob = "figure5/spt6_2018_figure5-intragenic-promoters.Rdata",
    params:
        height = eval(str(config["figure_five"]["height"])),
        width = eval(str(config["figure_five"]["width"])),
    script:
        "../scripts/spt6_2018_figure5.R"

