#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figure1/figure1B/spt6_2018_figure1B-TSS-seq-average-signal.png",
        "figure1/figure1C/spt6_2018_figure1C-TSS-seq-heatmaps.png",

include:
    "rules/figure_1.smk"
