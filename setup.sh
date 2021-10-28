#!/bin/bash

# VirSearch installer script
# (C) 2021 EMBL - EBI

# uncomment to delete existing env
#conda env remove --name virsearch

echo "Installing VirSearch"
mamba create -c conda-forge -c bioconda -n virsearch snakemake

conda activate virsearch

echo "Creating required envs"
conda env create -f envs/deepvirfinder.yml
conda env create -f envs/checkv.yml
conda env create -f envs/virsorter2.yml
conda env create -f envs/vibrant.yml

echo "Final settings"
conda env config vars set SNAKEMAKE_OUTPUT_CACHE=/hps/software/users/rdf/metagenomics/service-team/caches/snakemake

echo "All done"