#!/bin/bash
#SBATCH --job-name=magpy
#SBATCH -D . # Directorio del trabajo
#SBATCH -o PROK_data_%j.out # archivo de salida estandar
#SBATCH -e PROK_data_%j.err # archivo de salida de error
#SBATCH -J ProkkaP # nombre del trabajo
#SBATCH -n 32 # numero de cores a solicitar
#SBATCH -N 2 # numero de nodos a solicitar
# Script for Annotation using Prokka

module load devtools/python/2.7.12
module load software/bioinformatics/hmmer/3.1b2
module load software/bioinformatics/spades/3.10.1
module load software/bioinformatics/MAGpy/
module load devtools/bioconda/bioconda3
source activate magpy_env
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/

for FILE in *.fastq; do snakemake --use-conda --cluster-config MAGpy.json --cluster "qsub -V -cwd -pe sharedmem {cluster.core} -l h_rt= {cluster.time} -l h_vmem={cluster.vmem} -P {cluster.proj}" --jobs 1000 $FILE; done
