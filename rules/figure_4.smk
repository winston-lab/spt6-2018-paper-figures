#!/usr/bin/env python

localrules: assemble_figure_four

#metagene of MNase-seq
rule figure_four_a:
    input:
        mnase_data = config["figure_four"]["four_a"]["mnase_data"],
        annotation = config["figure_four"]["four_a"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.svg",
        pdf = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.pdf",
        png = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.png",
        grob = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_a"]["height"])),
        width = eval(str(config["figure_four"]["four_a"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_figure4A.R"

# nucleosome dyad signal, occupancy, and fuzziness aligned to TSS/plusone nuc dyad,
# sorted by NETseq signal
rule figure_four_b:
    input:
        netseq_data = config["figure_four"]["four_b"]["netseq_data"],
        mnase_data = config["figure_four"]["four_b"]["mnase_data"],
        quant_data = config["figure_four"]["four_b"]["quant_data"],
        annotation = config["figure_four"]["four_b"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4B/spt6_2018_figure4B-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.svg",
        pdf = "figure4/figure4B/spt6_2018_figure4B-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.pdf",
        png = "figure4/figure4B/spt6_2018_figure4B-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.png",
        grob = "figure4/figure4B/spt6_2018_figure4B-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_b"]["height"])),
        width = eval(str(config["figure_four"]["four_b"]["width"])),
        assay = "NET-seq"
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_figure4B.R"

# nucleosome dyad signal, occupancy, and fuzziness aligned to TSS/plusone nuc dyad,
# sorted by NETseq signal
rule figure_four_b_extra:
    input:
        netseq_data = config["figure_four"]["four_b_extra"]["netseq_data"],
        mnase_data = config["figure_four"]["four_b_extra"]["mnase_data"],
        quant_data = config["figure_four"]["four_b_extra"]["quant_data"],
        annotation = config["figure_four"]["four_b_extra"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4Bextra/spt6_2018_figure4Bextra-MNase-dyad-signal-occupancy-fuzziness-TFIIB-sorted.svg",
        pdf = "figure4/figure4Bextra/spt6_2018_figure4Bextra-MNase-dyad-signal-occupancy-fuzziness-TFIIB-sorted.pdf",
        png = "figure4/figure4Bextra/spt6_2018_figure4Bextra-MNase-dyad-signal-occupancy-fuzziness-TFIIB-sorted.png",
        grob = "figure4/figure4Bextra/spt6_2018_figure4Bextra-MNase-dyad-signal-occupancy-fuzziness-TFIIB-sorted.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_b"]["height"])),
        width = eval(str(config["figure_four"]["four_b"]["width"])),
        assay = "TFIIB"
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_figure4B.R"

#global quantification of nucleosome occupancy and fuzziness
rule figure_four_c:
    input:
        wt_mnase_quant = config["figure_four"]["four_c"]["wt_mnase_quant"],
        spt6_mnase_quant = config["figure_four"]["four_c"]["spt6_mnase_quant"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.svg",
        pdf = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.pdf",
        png = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.png",
        grob = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_c"]["height"])),
        width = eval(str(config["figure_four"]["four_c"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_figure4C.R"

#MNase-seq browser view and H3 ChIP-qPCR
rule figure_four_d:
    input:
        plot_functions = "scripts/coverage_and_qpcr_plotting_functions.R",
        vam6_mnase_path = config["figure_four"]["four_d"]["vam6_mnase_path"],
        qpcr_data = config["figure_four"]["four_d"]["qpcr_data"],
        annotation = config["figure_four"]["four_d"]["annotation"],
        theme = config["theme_spec"]
    output:
        svg = "figure4/figure4D/spt6_2018_figure4D-VAM6-MNase-seq-and-H3-qPCR.svg",
        pdf = "figure4/figure4D/spt6_2018_figure4D-VAM6-MNase-seq-and-H3-qPCR.pdf",
        png = "figure4/figure4D/spt6_2018_figure4D-VAM6-MNase-seq-and-H3-qPCR.png",
        grob = "figure4/figure4D/spt6_2018_figure4D-VAM6-MNase-seq-and-H3-qPCR.Rdata",
    params:
        height = eval(str(config["figure_four"]["four_d"]["height"])),
        width = eval(str(config["figure_four"]["four_d"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_figure4D.R"

rule assemble_figure_four:
    input:
        four_a = "figure4/figure4A/spt6_2018_figure4A-MNase-seq-average-signal.Rdata",
        four_b = "figure4/figure4B/spt6_2018_figure4B-MNase-dyad-signal-occupancy-fuzziness-NETseq-sorted.Rdata",
        four_c = "figure4/figure4C/spt6_2018_figure4C-MNase-global-quantification.Rdata",
        four_d = "figure4/figure4D/spt6_2018_figure4D-VAM6-MNase-seq-and-H3-qPCR.Rdata",
    output:
        svg = "figure4/spt6_2018_figure4-MNase-seq.svg",
        pdf = "figure4/spt6_2018_figure4-MNase-seq.pdf",
        png = "figure4/spt6_2018_figure4-MNase-seq.png",
        grob = "figure4/spt6_2018_figure4-MNase-seq.Rdata",
    params:
        height = eval(str(config["figure_four"]["height"])),
        width = eval(str(config["figure_four"]["width"])),
    conda: "../envs/tidyverse.yaml"
    script:
        "../scripts/spt6_2018_figure4.R"

