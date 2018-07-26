#!/usr/bin/env python

localrules: assemble_supp_four

#MNase-seq scatterplots
rule supp_four_a:
    input:
        mnase_data = config["figure_four"]["supp_a"]["mnase_data"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.svg",
        pdf = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.pdf",
        png = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.png",
        grob = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_four"]["supp_a"]["height"])),
        width = eval(str(config["figure_four"]["supp_a"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp4A.R"

rule supp_four_b:
    input:
        mnase_data = config["figure_four"]["supp_b"]["mnase_data"],
        annotation = config["figure_four"]["supp_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.svg",
        pdf = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.pdf",
        png = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.png",
        grob = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.Rdata",
    params:
        assay = "sense NET-seq",
        height = eval(str(config["figure_four"]["supp_b"]["height"])),
        width = eval(str(config["figure_four"]["supp_b"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp4B.R"

rule supp_four_b_extra:
    input:
        mnase_data = config["figure_four"]["supp_b_extra"]["mnase_data"],
        annotation = config["figure_four"]["supp_b_extra"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/supp4Bextra/spt6_2018_supp4Bextra-MNase-seq-metagene-by-TFIIB-levels.svg",
        pdf = "figure4/supp4Bextra/spt6_2018_supp4Bextra-MNase-seq-metagene-by-TFIIB-levels.pdf",
        png = "figure4/supp4Bextra/spt6_2018_supp4Bextra-MNase-seq-metagene-by-TFIIB-levels.png",
        grob = "figure4/supp4Bextra/spt6_2018_supp4Bextra-MNase-seq-metagene-by-TFIIB-levels.Rdata",
    params:
        assay = "genic TFIIB",
        height = eval(str(config["figure_four"]["supp_b"]["height"])),
        width = eval(str(config["figure_four"]["supp_b"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp4B.R"

rule supp_four_c:
    input:
        pma1_mnase = config["figure_four"]["supp_c"]["pma1_mnase"],
        hsp82_mnase = config["figure_four"]["supp_c"]["hsp82_mnase"],
        qpcr_data = config["figure_four"]["supp_c"]["qpcr_data"],
        plot_functions = "scripts/coverage_and_qpcr_plotting_functions.R",
        theme = config["theme_spec"]
    output:
        svg = "figure4/supp4C/spt6_2018_supp4C-PMA1-HSP82-H3-ChIP.svg",
        pdf = "figure4/supp4C/spt6_2018_supp4C-PMA1-HSP82-H3-ChIP.pdf",
        png = "figure4/supp4C/spt6_2018_supp4C-PMA1-HSP82-H3-ChIP.png",
        grob = "figure4/supp4C/spt6_2018_supp4C-PMA1-HSP82-H3-ChIP.Rdata",
    params:
        height = eval(str(config["figure_four"]["supp_c"]["height"])),
        width = eval(str(config["figure_four"]["supp_c"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp4C.R"

rule assemble_supp_four:
    input:
        four_a = "figure4/supp4A/spt6_2018_supp4A-MNase-seq-scatterplots.Rdata",
        four_b = "figure4/supp4B/spt6_2018_supp4B-MNase-seq-metagene-by-NETseq-levels.Rdata",
        four_c = "figure4/supp4C/spt6_2018_supp4C-PMA1-HSP82-H3-ChIP.Rdata",
    output:
        svg = "figure4/spt6_2018_supp4-MNase-seq.svg",
        pdf = "figure4/spt6_2018_supp4-MNase-seq.pdf",
        png = "figure4/spt6_2018_supp4-MNase-seq.png",
        grob = "figure4/spt6_2018_supp4-MNase-seq.Rdata",
    params:
        height = eval(str(config["figure_four"]["supp_height"])),
        width = eval(str(config["figure_four"]["supp_width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp4.R"

