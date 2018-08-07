#!/usr/bin/env python

rule get_unassigned_tss_peaks:
    input:
        allpeaks =  config["supp_tables"]["tss"]["all"],
        genic =  config["supp_tables"]["tss"]["genic"],
        intragenic =  config["supp_tables"]["tss"]["intragenic"],
        antisense =  config["supp_tables"]["tss"]["antisense"],
        intergenic =  config["supp_tables"]["tss"]["intergenic"],
    output:
        "supp_tables/unassigned-tss-seq-peaks.tsv"
    shell: """
        cat <(tail -n +2 {input.genic} | cut -f4) <(tail -n +2 {input.intragenic} | cut -f4) <(tail -n +2 {input.antisense} | cut -f4) <(tail -n +2 {input.intergenic} | cut -f4) | sort -u | grep -v -f - {input.allpeaks} > {output}
        """
