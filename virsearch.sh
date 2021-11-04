#!/bin/bash

set -e

# virsearch.sh
# Script to run virsearch on a set of fasta files
# Usage: virsearch.sh -i <input dir with fasta files (.fa)> -o <output dir> -n <number of threads> -e <cluster or single execution>
# (C)opyright 2021 by EMBL - EBI

INPUTDIR='none'
OUTPUTDIR='none'
NUMTHREADS=4
EXECUTION='single'
VIRSEARCHDIR=/nfs/production/rdf/metagenomics/pipelines/prod/virsearch
CONDA_ACTIVATE=/hps/software/users/rdf/metagenomics/service-team/software/miniconda_py39/bin/activate
CONDA_ENV=virsearch

error_exit()
{
    echo "ERROR: $1" 1>&2
    exit 1
}

while getopts "h?:m:p:e:" args; do
  case $args in
      h|\?)
          echo "Usage: virsearch.sh -i <input dir with fasta files (.fa)> -o <output dir> [-n <number of threads>] [-e <cluster or single execution>]";
          exit
          ;;
      i) INPUTDIR=${OPTARG};;
      o) OUTPUTDIR=${OPTARG};;
      n) NUMTHREADS=${OPTARG};;
      e) EXECUTION=${OPTARG};;
      *)
          echo "Invalid Option" 1>&2
          exit 1
          ;;
    esac
done

if [ "${INPUTDIR}" == "none" ] || \
   [ "${OUTPUTDIR}" == "none" ] 
then
    error_exit "Missing mandatory input/output parameter."
fi

if [ -d "$INPUTDIR" ]
then
    echo "Input directory: $INPUTDIR"
else
    error_exit "ERROR: Input directory does not exist."
fi

if [ -d "$OUTPUTDIR" ]
then
    echo "Output directory: $OUTPUTDIR"
else
    echo "Creating outoput directory $OUTPUTDIR"
    mkdir -p "$OUTPUTDIR" || error_exit "Cannot create directory $OUTPUTDIR" 
fi

echo "Activating conda env"
source "${CONDA_ACTIVATE}" "${CONDA_ENV}"

if [ "${EXECUTION}" == "cluster" ]
then
    echo "Execution mode: cluster"
    snakemake -k -s "$VIRSEARCHDIR/Snakemake" -j $NUMTHREADS --cluster-config "$VIRSEARCHDIR/cluster.yml" --cluster 'bsub -n {cluster.nCPU} -M {cluster.mem} -o {cluster.output}' --config input="$INPUTDIR" output="$OUTPUTDIR"
else
    echo "Execution mode: single"
    snakemake -k -s "$VIRSEARCHDIR/Snakemake" -j $NUMTHREADS --config input="$INPUTDIR" output="$OUTPUTDIR"
fi
