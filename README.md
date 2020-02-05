#Pipeline ColBuff
# Project Workflow for Differences in methane emissions in two cohorts of Colombian buffalos were not associated with significant changes in their rumen microbiome
#

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Multipe Bioinformatics Tools, Conda, BioConda, Python 3.X, MPI, OpenMP, SLURM HTC/HPC, snakemake

```
Example
conda install bwa
```

### Running Pipeline

To obtain sequences with optimal bases quality, suitable for assembly and alignment.

```
for i in ./TrimmedOutputs/*.fastq
do
	fastqc -o ./outputs $i 
done
```

To match the reads in their 5´and 3´ sequences, for their optimal assembly and alignment performance.

```
for i in ./tempData/*.fastq
do
        f="$(basename -- $i)"
	fastq-mcf adapters.fa -o ${f}_trim30.fastq $i -k 0 -l 120 -w 3 -q 30
done
```
To increase the size of our shotgun sequences and find the relative contribution of each sample on each contig.
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
