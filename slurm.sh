#!/bin/bash

#SBATCH -p priority
#SBATCH -t 6:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH -n 1
#SBATCH -e snakemake.err
#SBATCH -o snakemake.log
#SBATCH -J spt6_2018_figures

snakemake -Fp -R `cat <(snakemake --lc) <(snakemake --li) <(snakemake --lp)` --latency-wait 300 --rerun-incomplete --cluster-config cluster.yaml --use-conda --jobs 999 --restart-times 1 --cluster "sbatch -p {cluster.queue} -n {cluster.n} -t {cluster.time} --mem-per-cpu={cluster.mem} -J {cluster.name} -e {cluster.err} -o {cluster.log}"
