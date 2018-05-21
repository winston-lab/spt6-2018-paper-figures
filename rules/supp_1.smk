#!/usr/bin/env python

#TSS-seq scatterplots
rule supp_one_a:
    input:
        tss_data = config["figure_one"]["supp_a"]["tss_data"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.svg",
        pdf = "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.pdf",
        png = "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.png",
        grob = "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_a"]["height"])),
        width = eval(str(config["figure_one"]["supp_a"]["width"])),
    script:
        "../scripts/spt6_2018_supp1A.R"

#TSS-seq vs Malabat
rule supp_one_b:
    input:
        tss_data = config["figure_one"]["supp_b"]["tss_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.svg",
        pdf = "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.pdf",
        png = "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.png",
        grob = "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_b"]["height"])),
        width = eval(str(config["figure_one"]["supp_b"]["width"])),
    script:
        "../scripts/spt6_2018_supp1B.R"

# histogram of intragenic starts per ORF
rule supp_one_d:
    input:
        intra_diffexp_data = config["figure_one"]["supp_d"]["intra_diffexp_data"],
        orf_anno = config["figure_one"]["supp_d"]["orf_anno"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.svg",
        pdf = "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.pdf",
        png = "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.png",
        grob = "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_d"]["height"])),
        width = eval(str(config["figure_one"]["supp_d"]["width"])),
    script:
        "../scripts/spt6_2018_supp1D.R"

