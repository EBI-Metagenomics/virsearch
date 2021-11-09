# VirSearch - searching viral sequences in metagenomes

[Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) workflow to detect and classify viruses in metagenome assemblies.

It first detects viral sequences in assemblies (`.fa` files) with [VirSorter2](https://github.com/jiarong/VirSorter2), [VIBRANT](https://github.com/AnantharamanLab/VIBRANT) and [DeepVirFinder](https://github.com/jessieren/DeepVirFinder). Predictions are strictly quality controlled with [CheckV](https://bitbucket.org/berkeleylab/checkv), followed by clustering with [CD-HIT](http://weizhongli-lab.org/cd-hit/) and taxonomic classification with [Demovir](https://github.com/feargalr/Demovir).

## Installation

1. Install [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) and get [USEARCH](https://www.drive5.com/usearch/download.html).

2. Clone repository
```
git clone --recursive https://github.com/EBI-Metagenomics/virsearch.git
```

3. Create the conda environment (it will install all tools and Snakemake inside a conda env named "virsearch").

```
conda env create -f envs/virsearch.yml
conda activate virsearch
```

4. Download and extract necessary databases (uncompressed directory will require a total of 30 GB).

```
wget http://ftp.ebi.ac.uk/pub/databases/metagenomics/genome_sets/virsearch_db.tar.gz
tar -xzvf virsearch_db.tar.gz
```

## How to run

1. Edit `config.yml` file to point to the <b>input</b>, <b>output</b> and <b>databases</b> directories, as well as the [USEARCH](https://www.drive5.com/usearch/download.html) binary location (`usearch_binary`). Input directory should contain the `.fa` assemblies to analyse.

2. (option 1) Run the pipeline locally (adjust `-j` based on the number of available cores)
```
snakemake --use-conda -k -j 4
```
2. (option 2) Run the pipeline on a cluster (e.g., LSF)
```
snakemake --use-conda -k -j 100 --cluster-config cluster.yml --cluster 'bsub -n {cluster.nCPU} -M {cluster.mem} -o {cluster.output}'
```

### EBI Codon execution
The `virsearch.sh` file is a wrapper script to run the pipeline on EBI Codon.

Usage:

```
virsearch.sh -i <input dir with fasta files (.fa)> -o <output dir> [-n <number of threads>] [-e <cluster or single execution>]
```

## Output

The main output files generated per input FASTA are the `final_predictions.fa` and `final_predictions_tax.tsv` files, which contain the viral sequences in FASTA format and their taxonomic annotation, respectively. If these files are empty it likely means that no high-confidence viral sequences were detected (check individual logs of the tools to confirm no other issues arose).
