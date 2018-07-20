#!/usr/bin/env python

localrules: assemble_supp_two

#TFIIB ChIPnexus scatterplots
rule supp_two_a:
    input:
        tfiib_data = config["figure_two"]["supp_a"]["tfiib_data"],
        scatterplot_script = "scripts/plot_scatter_plots.R",
        theme = config["theme_spec"]
    output:
        svg = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.svg",
        pdf = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.pdf",
        png = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.png",
        grob = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_two"]["supp_a"]["height"])),
        width = eval(str(config["figure_two"]["supp_a"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp2A.R"

#TFIIB ChIPnexus scatterplots
rule supp_two_b:
    input:
        data_path = config["figure_two"]["supp_b"]["data_path"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.svg",
        pdf = "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.pdf",
        png = "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.png",
        grob = "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.Rdata",
    params:
        height = eval(str(config["figure_two"]["supp_b"]["height"])),
        width = eval(str(config["figure_two"]["supp_b"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp2B.R"

#TFIIB ChIPnexus scatterplots
rule supp_two_c:
    input:
        sense_tfiib_data = config["figure_two"]["supp_c"]["sense_tfiib_data"],
        antisense_tfiib_data = config["figure_two"]["supp_c"]["antisense_tfiib_data"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.svg",
        pdf = "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.pdf",
        png = "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.png",
        grob = "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.Rdata",
    params:
        height = eval(str(config["figure_two"]["supp_c"]["height"])),
        width = eval(str(config["figure_two"]["supp_c"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp2C.R"

#TFIIB Western
rule supp_two_d:
    input:
        data_path = config["figure_two"]["supp_d"]["data"],
        image = config["figure_two"]["supp_d"]["image"],
        theme = config["theme_spec"]
    output:
        svg = "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.svg",
        pdf = "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.pdf",
        png = "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.png",
        grob = "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.Rdata",
    params:
        height = eval(str(config["figure_two"]["supp_d"]["height"])),
        width = eval(str(config["figure_two"]["supp_d"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp2D.R"

rule assemble_supp_two:
    input:
        supp_two_a = "figure2/supp2A/spt6_2018_supp2A-TFIIB-ChIPnexus-scatterplots.Rdata",
        supp_two_b = "figure2/supp2B/spt6_2018_supp2B-TFIIB-ChIPnexus-v-ChIPexo-scatterplots.Rdata",
        supp_two_c = "figure2/supp2C/spt6_2018_supp2C-TFIIB-ChIPnexus-average-signal-TATAs.Rdata",
        supp_two_d = "figure2/supp2D/spt6_2018_supp2D-TFIIB-western.Rdata",
    output:
        svg = "figure2/spt6_2018_supp2-TFIIB-ChIP-nexus.svg",
        pdf = "figure2/spt6_2018_supp2-TFIIB-ChIP-nexus.pdf",
        png = "figure2/spt6_2018_supp2-TFIIB-ChIP-nexus.png",
        grob = "figure2/spt6_2018_supp2-TFIIB-ChIP-nexus.Rdata",
    params:
        height = eval(str(config["figure_two"]["supp_height"])),
        width = eval(str(config["figure_two"]["supp_width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_supp2.R"

