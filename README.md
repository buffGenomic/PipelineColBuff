#Pipeline ColBuff
# Project Workflow for Differences in methane emissions in two cohorts of Colombian buffalos were not associated with significant changes in their rumen microbiome
#

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Multipe Bioinformatics Tools, Conda, BioConda, Python 3.X, MPI, OpenMP, SLURM HTC/HPC, snakemake
Multipe Bioinformatics Tools are required for implementing this pipeline. However, to prevent conflicting versions of required software in each case, we suggest to install packages using the conda package manager (https://docs.conda.io/projects/conda/en/latest/index.html ) in separate environments. Many bioinformatics software are available in the Bioconda repository (https://anaconda.org/bioconda/).
Notes:
1. All command lines assume that the required software has been installed as above.
2. $PWD refers to the working directory where data is

```
conda create -n <environment_name> -c  <channel>  <software_name>
 
Or simply by:
conda install <software_name>

# This last command will not install the software in a separate environment and could run into conflicting issues with different software versions.
```

### Running Pipeline

To inspect quality scores of bases, run the following command

```
fastqc *.fastq
# Fastq files can also be in a compressed format
For multiple files
for i in ./TrimmedOutputs/*.fastq
do
	fastqc -o ./outputs $i 
done
```

To trim the reads in their 5´and 3´ sequences, according to a user-defined quality threshold (Q>30 in this case), a minimal length of 120 bases and using a window size of three bases for quality trimming (it requires a FASTA file containing the sequence of adapters to be trimmed). The following example is for compressed files with file name in the following format sample_R[1-2].fastq.gz:

```
for FILE in $PWD/*R1.fastq.gz; do fastq-mcf adapters.fa -o ${FILE/R1.fastq.gz/trim.fq.gz} -o  ${FILE/R1.fastq.gz/R2.trim.fq.gz} $FILE ${FILE/R1/R2} -k 0 -l 120 -w 3 -q 30
```
In to conduct combined assembly (all samples together), files have to be concatenated. All files corresponding to end1 (R1 files) will be combined and the same will be done for end2 files (R2).
Concatenate all files corresponding to end1 and end2 (example with compressed files):
```
cat *R1.fastq.gz > allSamples_R1.fq.gz
cat *R2.fastq.gz > allSamples_R2.fq.gz
```
To increase the size of our shotgun sequences and find the relative contribution of each sample on each contig.
```
metaspades.py -1 allSamples_R1.fq.gz -2 allSamples_R2.fq.gz -o allSamples_spades
```
Combined assembly is then conducted with SPAdes (http://cab.spbu.ru/software/spades/):
```
for FILE in $(ls *R1.fastq | sed 's/_R1.fastq//'); do metaspades.py -1 ${FILE}_R1.fastq -2 ${FILE}_R2.fastq -o ${FILE}; done
```

To increase the size and number of contigs and generate the "bins" (individual putative genomes).
```
for FILE in $(ls *Comb.fastq | sed 's/_Comb.fastq//'); do metaspades.py -1 ${FILE}Comb1.fastq -2 ${FILE}Comb2.fastq -o ${FILE}; done
```

For protein prediction by de novo assembly
```
for FILE in $(ls *R1.fastq | sed 's/_R1.fastq//'); do plass assemble ${FILE}_R1.fastq -2 ${FILE}_R2.fastq assembly.fas tmp; done
```
For the identification of the genomic characteristics contained in our individual contigs.
```
for FILE in scaffolds.fasta; do prokka --cpus 24 --centre X --compliant --outdir ${FILE/_metaspades*/_prokka}1 --prefix ${FILE/_metaspades*/} $FILE; done
```
For the identification of the genomic characteristics contained in our combined contigs.
```
for FILE in scaffoldsCombined.fasta; do prokka --cpus 24 --centre X --compliant --outdir ${FILE/_metaspades*/_prokka}1 --prefix ${FILE/_metaspades*/} $FILE; done
```
To eliminate redundancy and reunite families.
```
metabat2 -i scaffolds.fasta -a depth.txt -o bins_dir/bin
```
To obtain our set of non-redundant protein sequences
```
mmseqs easy-linclust prokka_PLASS_allSamples.faa clusterRes tmp
```
To obtain phylogenetic relationships according to each bin
```
for FILE in *.fastq; do snakemake --use-conda --cluster-config MAGpy.json --cluster "qsub -V -cwd -pe sharedmem {cluster.core} -l h_rt= {cluster.time} -l h_vmem={cluster.vmem} -P {cluster.proj}" --jobs 1000 $FILE; done
```
To get the best hits for subsequent scoring
```
diamond blastp -d rumiref100.dmnd -q clusterRes_rep_seq.fasta --threads 12 -o clusterRes_rep_seq-rumiref100.out
```
For the realization of statistical comparisons by linear discriminant analysis
```
format_input.py *.txt *.in -c 1 -s 2 -u 3 -o 1000000
run_lefse.py *.in hmp_Ressmall.res
```
