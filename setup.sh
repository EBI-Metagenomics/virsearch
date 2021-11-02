#!/bin/bash

# VirSearch installer script
# (C) 2021 EMBL - EBI

ENV_PATH=/hps/software/users/rdf/metagenomics/service-team/software/miniconda_py39/envs

# uncomment to delete existing env
#conda env remove --name virsearch
#rm -rf $ENV_PATH/virsearch

echo "Creating VirSearch conda environment"
conda env create -f envs/virsearch.yml
conda activate virsearch

echo "Retriving database"
wget http://ftp.ebi.ac.uk/pub/databases/metagenomics/genome_sets/virsearch_db.tar.gz
tar -zxf virsearch_db.tar.gz
rm virsearch_db.tar.gz

echo "Final settings"
conda env config vars set SNAKEMAKE_OUTPUT_CACHE=/hps/software/users/rdf/metagenomics/service-team/caches/snakemake

echo "All done"