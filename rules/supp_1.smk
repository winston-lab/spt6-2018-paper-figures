#!/usr/bin/env python

localrules: assemble_supp_one

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
    conda: "../envs/plot.yaml"
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
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp1B.R"

#TSS-seq vs Malabat
rule supp_one_c:
    input:
        data_path = config["figure_one"]["supp_c"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.svg",
        pdf = "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.pdf",
        png = "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.png",
        grob = "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_c"]["height"])),
        width = eval(str(config["figure_one"]["supp_c"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp1C.R"

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
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp1D.R"

# position bias of intragenic TSSs
rule supp_one_e:
    input:
        diffexp_results = config["figure_one"]["supp_e"]["diffexp_results"],
        positions = config["figure_one"]["supp_e"]["positions"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1E/spt6_2018_supp1E-intra-TSS-position-bias.svg",
        pdf = "figure1/supp1E/spt6_2018_supp1E-intra-TSS-position-bias.pdf",
        png = "figure1/supp1E/spt6_2018_supp1E-intra-TSS-position-bias.png",
        grob = "figure1/supp1E/spt6_2018_supp1E-intra-TSS-position-bias.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_e"]["height"])),
        width = eval(str(config["figure_one"]["supp_e"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp1E.R"

# bvenn of cheung09, uwimana17, tss-seq genes with intragenic starts
rule supp_one_f:
    input:
        common_names = config["figure_one"]["supp_f"]["common_names"],
        cheung_data = config["figure_one"]["supp_f"]["cheung_data"],
        uwimana_data = config["figure_one"]["supp_f"]["uwimana_data"],
        tss_data = config["figure_one"]["supp_f"]["tss_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1F/spt6_2018_supp1F-genes-with-intragenic-TSS-vs-cheung08-uwimana17.svg",
        pdf = "figure1/supp1F/spt6_2018_supp1F-genes-with-intragenic-TSS-vs-cheung08-uwimana17.pdf",
        png = "figure1/supp1F/spt6_2018_supp1F-genes-with-intragenic-TSS-vs-cheung08-uwimana17.png",
        grob = "figure1/supp1F/spt6_2018_supp1F-genes-with-intragenic-TSS-vs-cheung08-uwimana17.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_f"]["height"])),
        width = eval(str(config["figure_one"]["supp_f"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp1F.R"

rule assemble_supp_one:
    input:
        supp_one_a = "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.Rdata",
        supp_one_b  = "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.Rdata",
        supp_one_c = "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.Rdata",
        supp_one_d = "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.Rdata",
        supp_one_e = "figure1/supp1E/spt6_2018_supp1E-intra-TSS-position-bias.Rdata",
        supp_one_f = "figure1/supp1F/spt6_2018_supp1F-genes-with-intragenic-TSS-vs-cheung08-uwimana17.Rdata",
    output:
        svg = "figure1/spt6_2018_supp1-TSS-seq.svg",
        pdf = "figure1/spt6_2018_supp1-TSS-seq.pdf",
        png = "figure1/spt6_2018_supp1-TSS-seq.png",
        grob = "figure1/spt6_2018_supp1-TSS-seq.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_height"])),
        width = eval(str(config["figure_one"]["supp_width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt6_2018_supp1.R"

