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
    script:
        "../scripts/spt6_2018_supp1D.R"

# bvenn of cheung09, uwimana17, tss-seq genes with intragenic starts
rule supp_one_e:
    input:
        common_names = config["figure_one"]["supp_e"]["common_names"],
        cheung_data = config["figure_one"]["supp_e"]["cheung_data"],
        uwimana_data = config["figure_one"]["supp_e"]["uwimana_data"],
        tss_data = config["figure_one"]["supp_e"]["tss_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.svg",
        pdf = "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.pdf",
        png = "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.png",
        grob = "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_e"]["height"])),
        width = eval(str(config["figure_one"]["supp_e"]["width"])),
    script:
        "../scripts/spt6_2018_supp1E.R"

rule assemble_supp_one:
    input:
        supp_one_a = "figure1/supp1A/spt6_2018_supp1A-TSS-seq-scatterplots.Rdata",
        supp_one_b  = "figure1/supp1B/spt6_2018_supp1B-TSS-seq-vs-malabat15.Rdata",
        supp_one_c = "figure1/supp1C/spt6_2018_supp1C-TSS-seq-vs-uwimana17-RNA-seq.Rdata",
        supp_one_d = "figure1/supp1D/spt6_2018_supp1D-intra-TSS-per-ORF-histogram.Rdata",
        supp_one_e = "figure1/supp1E/spt6_2018_supp1E-genes-with-intragenic-TSS-vs-cheung08-uwimana17.Rdata",
    output:
        svg = "figure1/spt6_2018_supp1-TSS-seq.svg",
        pdf = "figure1/spt6_2018_supp1-TSS-seq.pdf",
        png = "figure1/spt6_2018_supp1-TSS-seq.png",
        grob = "figure1/spt6_2018_supp1-TSS-seq.Rdata",
    params:
        height = eval(str(config["figure_one"]["supp_height"])),
        width = eval(str(config["figure_one"]["supp_width"])),
    script:
        "../scripts/spt6_2018_supp1.R"
