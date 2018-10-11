
# [Spt6 2018](https://doi.org/10.1101/347575) paper figures

## description

The code used to produce the figures and supplemental tables for [our publication](https://doi.org/10.1016/j.molcel.2018.09.005). An archived version suitable for reproducing the paper's figures starting from raw data is available at [Zenodo](https://doi.org/10.5281/zenodo.1409826).

## requirements

### required software

- Unix-like operating system (tested on CentOS 7.2.1511)
- Git
- [conda](https://conda.io/docs/user-guide/install/index.html)
- [snakemake](https://snakemake.readthedocs.io/en/stable/)

### required files

All input files are present or generated by the pipelines in the following directories in the [Zenodo archive](https://doi.org/10.5281/zenodo.1325930):

- `genomefiles_cerevisiae`
- `tss-seq-publication`
- `chipnexus-tfiib-publication`
- `chipnexus-spt6-v-rnapii`
- `net-seq-publication`
- `mnase-seq-publication`
- `cluster_intragenic_mnase`
- `tss-v-tfiib-nexus-publication`
- `assay-correlations-publication`
- `spt6-data-integration`
- `motif_analysis_tata`
- `motif_analysis_allmotifs`
- `spt6-small-data`
- `other-datasets/malabat15`
- `other-datasets/uwimana17`
- `other-datasets/rhee12`
- `other-datasets/cheung08`

## instructions
**0**. Run the pipelines in the directories listed above in the [Zenodo archive](https://doi.org/10.5281/zenodo.1409826).

**1**. Do a dry run of the pipeline to see what files will be created.

```bash
snakemake -p --use-conda --dry-run
```

**2**. If running the pipeline on a local machine, you can run the pipeline using the above command, omitting the `--dry-run` flag. You can also use N cores by specifying the `--cores N` flag. The first time the pipeline is run, conda will create separate virtual environments for some of the jobs to operate in. To run the pipeline using the SLURM job scheduler on the HMS O2 cluster, enter `sbatch slurm.sh` to submit the pipeline as a single job which will spawn individual subjobs as necessary. This can be adapted to other job schedulers and clusters by modifying `slurm.sh` and `cluster.yaml`, which specifies the resource requests for each type of job.

