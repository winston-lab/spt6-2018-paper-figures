#!/usr/bin/env python

localrules: get_unassigned_tss_peaks, cat_tss_peaks,
    get_unassigned_tfiib_peaks, cat_tfiib_peaks

rule get_unassigned_tss_peaks:
    input:
        allpeaks =  config["supp_tables"]["tss"]["all"],
        allpeaks_narrowpeak =  config["supp_tables"]["tss"]["all_narrowpeak"],
        genic =  config["supp_tables"]["tss"]["genic"],
        intragenic =  config["supp_tables"]["tss"]["intragenic"],
        antisense =  config["supp_tables"]["tss"]["antisense"],
        intergenic =  config["supp_tables"]["tss"]["intergenic"],
    output:
        temp("supp_tables/unassigned-tss-seq-peaks.tsv")
    shell: """
        cat <(tail -n +2 {input.genic} | cut -f4) <(tail -n +2 {input.intragenic} | cut -f4) <(tail -n +2 {input.antisense} | cut -f4) <(tail -n +2 {input.intergenic} | cut -f4) | sort -u | join -t "\t" -1 1 -2 4 -o 2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,2.10,2.11,2.12,2.13,2.14 -v 2 - <(tail -n +2 {input.allpeaks} | sort -k4,4) | join -t "\t" -j 4 -o 1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,1.10,1.11,1.12,1.13,1.14,2.10 - <(sort -k4,4 {input.allpeaks_narrowpeak}) > {output}
        """

rule cat_tss_peaks:
    input:
        genic =  config["supp_tables"]["tss"]["genic"],
        intragenic =  config["supp_tables"]["tss"]["intragenic"],
        antisense =  config["supp_tables"]["tss"]["antisense"],
        intergenic =  config["supp_tables"]["tss"]["intergenic"],
        unassigned = "supp_tables/unassigned-tss-seq-peaks.tsv"
    output:
        "supp_tables/spt6_2018_supplemental_table_1_TSS-seq_peaks.csv"
    shell: """
        cat <(echo -e "peak_chrom\tpeak_start\tpeak_end\tpeak_id\tpeak_score\tpeak_strand\tlog2_foldchange\tlfc_SE\tstat\tlog10_pval\tlog10_padj\tmean_expr\tcondition_expr\tcontrol_expr\tpeak_summit\tfeature_chrom\tfeature_start\tfeature_end\tfeature_id\tfeature_score\tfeature_strand\tdistance\tpeak_category") <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "NA", "genic"}}' {input.genic}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "intragenic"}}' {input.intragenic}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "antisense"}}' {input.antisense}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "NA", "NA", "NA", "NA", "NA", "NA", "NA", "intergenic"}}' {input.intergenic}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "NA", "NA", "NA", "NA", "NA", "NA", "NA", "unassigned"}}' {input.unassigned}) | sed 's/,/_/g' | awk 'BEGIN{{FS="\t";OFS=","; print "# Supplemental Table 1: TSS-seq peaks\\n# peak_chrom: Chromosome the TSS-seq peak is on.\\n# peak_start: Starting position of the TSS-seq peak (zero-indexed; half-open).\\n# peak_end: Ending position of the TSS-seq peak (zero-indexed; half-open).\\n# peak_id: TSS-seq peak ID.\\n# peak_score: min(int(-125*log2(p-adj)); 1000). Useful for visualization in genome browser.\\n# peak_strand: The strand the TSS-seq peak is on.\\n# log2_foldchange: log2 of TSS-seq peak fold-change in condition over control (DESeq2).\\n# lfc_SE: Standard error of the mean for the log2(fold-change) estimate (DESeq2).\\n# log10_padj: -log10(p-adj); where p-adj is the p-value adjusted for multiple testing (DESeq2).\\n# condition_expr: normalized counts for the TSS-seq peak in spt6-1004 (DESeq2).\\n# control_expr: normalized counts for the TSS-seq peak in wild-type (DESeq2).\\n# peak_summit: Summit of the coverage in the TSS-seq peak; 0-based offset from peak_start.\\n# peak_category: genic; intragenic; antisense; intergenic; or unassigned.\\n# feature_chrom: If the TSS-seq peak is associated with a genomic feature; the chromosome that the feature is on.\\n# feature_start: If the TSS-seq peak is associated with a genomic feature; the starting position of the feature (zero-indexed; half-open).\\n# feature end: If the TSS-seq peak is associated with a genomic feature; the ending position of the feature (zero-indexed; half-open).\\n# feature_id: If the TSS-seq peak is associated with a genomic feature; the feature ID.\\n# feature_score: If the TSS-seq peak is associated with a genomic feature; the score of the feature (More or less useless; just to keep BED format).\\n# feature_strand: If the TSS-seq peak is associated with a genomic feature; the strand the feature is on.\\n# distance: If the peak is intragenic; the distance from ATG to the intragenic TSS-seq peak summit. If the peak is antisense; the distance from sense transcript start to the antisense TSS-seq peak summit."}}{{print $1, $2, $3, $4, $5, $6, $7, $8, $11, $13, $14, $15, $23, $16, $17, $18, $19, $20, $21, $22}}' > {output}
        """

rule get_unassigned_tfiib_peaks:
    input:
        allpeaks =  config["supp_tables"]["tfiib"]["all"],
        allpeaks_narrowpeak =  config["supp_tables"]["tfiib"]["all_narrowpeak"],
        genic =  config["supp_tables"]["tfiib"]["genic"],
        intragenic =  config["supp_tables"]["tfiib"]["intragenic"],
        intergenic =  config["supp_tables"]["tfiib"]["intergenic"],
    output:
        temp("supp_tables/unassigned-tfiib-nexus-peaks.tsv")
    shell: """
        cat <(tail -n +2 {input.genic} | cut -f4) <(tail -n +2 {input.intragenic} | cut -f4) <(tail -n +2 {input.intergenic} | cut -f4) | sort -u | join -t "\t" -1 1 -2 4 -o 2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,2.10,2.11,2.12,2.13,2.14 -v 2 - <(tail -n +2 {input.allpeaks} | sort -k4,4) | join -t "\t" -j 4 -o 1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,1.10,1.11,1.12,1.13,1.14,2.10 - <(sort -k4,4 {input.allpeaks_narrowpeak}) > {output}
        """

rule cat_tfiib_peaks:
    input:
        genic =  config["supp_tables"]["tfiib"]["genic"],
        intragenic =  config["supp_tables"]["tfiib"]["intragenic"],
        intergenic =  config["supp_tables"]["tfiib"]["intergenic"],
        unassigned = "supp_tables/unassigned-tfiib-nexus-peaks.tsv"
    output:
        "supp_tables/spt6_2018_supplemental_table_2_TFIIB-ChIP-nexus_peaks.csv"
    shell: """
        cat <(echo -e "peak_chrom\tpeak_start\tpeak_end\tpeak_id\tpeak_score\tpeak_strand\tlog2_foldchange\tlfc_SE\tstat\tlog10_pval\tlog10_padj\tmean_expr\tcondition_expr\tcontrol_expr\tpeak_summit\tfeature_chrom\tfeature_start\tfeature_end\tfeature_id\tfeature_score\tfeature_strand\tdistance\tpeak_category") <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "NA", "genic"}}' {input.genic}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "intragenic"}}' {input.intragenic}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "NA", "NA", "NA", "NA", "NA", "NA", "NA", "intergenic"}}' {input.intergenic}) <(awk 'BEGIN{{FS=OFS="\t"}} NR>1{{print $0, "NA", "NA", "NA", "NA", "NA", "NA", "NA", "unassigned"}}' {input.unassigned}) | sed 's/,/_/g' | awk 'BEGIN{{FS="\t";OFS=","; print "# Supplemental Table 2: TFIIB ChIP-nexus peaks\\n# peak_chrom: Chromosome the TFIIB ChIP-nexus peak is on.\\n# peak_start: Starting position of the TFIIB ChIP-nexus peak (zero-indexed; half-open).\\n# peak_end: Ending position of the TFIIB ChIP-nexus peak (zero-indexed; half-open).\\n# peak_id: TFIIB ChIP-nexus peak ID.\\n# peak_score: min(int(-125*log2(p-adj)); 1000). Useful for visualization in genome browser.\\n# peak_strand: . (We currently do not have strand information for ChIP-nexus peaks).\\n# log2_foldchange: log2 of TFIIB ChIP-nexus peak fold-change in condition over control (DESeq2).\\n# lfc_SE: Standard error of the mean for the log2(fold-change) estimate (DESeq2).\\n# log10_padj: -log10(p-adj); where p-adj is the p-value adjusted for multiple testing (DESeq2).\\n# condition_expr: normalized counts for the TFIIB ChIP-nexus peak in spt6-1004 (DESeq2).\\n# control_expr: normalized counts for the TFIIB ChIP-nexus peak in wild-type (DESeq2).\\n# peak_summit: Summit of the coverage in the TFIIB ChIP-nexus peak; 0-based offset from peak_start.\\n# peak_category: genic; intragenic; intergenic; or unassigned.\\n# feature_chrom: If the TFIIB ChIP-nexus peak is associated with a genomic feature; the chromosome that the feature is on.\\n# feature_start: If the TFIIB ChIP-nexus peak is associated with a genomic feature; the starting position of the feature (zero-indexed; half-open).\\n# feature end: If the TFIIB ChIP-nexus peak is associated with a genomic feature; the ending position of the feature (zero-indexed; half-open).\\n# feature_id: If the TFIIB ChIP-nexus peak is associated with a genomic feature; the feature ID.\\n# feature_score: If the TFIIB ChIP-nexus peak is associated with a genomic feature; the score of the feature (More or less useless; just to keep BED format).\\n# feature_strand: If the TFIIB ChIP-nexus peak is associated with a genomic feature; the strand the feature is on.\\n# distance: If the peak is intragenic; the distance from ATG to the intragenic TFIIB ChIP-nexus peak summit."}}{{print $1, $2, $3, $4, $5, $6, $7, $8, $11, $13, $14, $15, $23, $16, $17, $18, $19, $20, $21, $22}}' > {output}
        """
