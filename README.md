# VirSearch - searching viral sequences in metagenomes

Snakemake workflow to detect and classify viruses in metagenome assemblies.

It first detects viral sequences in assemblies (`.fa` files) with <b>VirSorter2</b>, <b>VIBRANT</b> and <b>DeepVirFinder</b>. Predictions are strictly quality controlled with <b>CheckV</b>, followed by clustering with <b>CD-HIT</b> and taxonomic classification with <b>DemoVir</b>.

## Installation

1. Clone repository
```
git clone https://github.com/alexmsalmeida/virsearch.git
```

2. Download and extract necessary databases

```
cd virsearch
wget http://ftp.ebi.ac.uk/pub/databases/metagenomics/genome_sets/databases.tar.gz
tar -xzvf databases.tar.gz
```

## How to run

1. Edit config.yml file to point to the input and output directories. Input directories should contain the `.fa` assemblies to analyse.

2. (option 1) Run the pipeline locally (adjust -j based on the number of available cores)
```
snakemake --use-conda -j 4
```
2. (option 2) Run the pipeline on a cluster (e.g. LSF)
```
snakemake --use-conda -j 50 --cluster-config cluster.yml --cluster "bsub -n {cluster.nCPU} -M {cluster.mem} -o {cluster.output}"
```
