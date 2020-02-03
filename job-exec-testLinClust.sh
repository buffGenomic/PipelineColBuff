#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -D . # Directorio del trabajo
#SBATCH -o PROK_data_%j.out # archivo de salida estandar
#SBATCH -e PROK_data_%j.err # archivo de salida de error
#SBATCH -J ProkkaP # nombre del trabajo
#SBATCH -n 32 # numero de cores a solicitar
#SBATCH -N 2 # numero de nodos a solicitar
# Script for clustering with mmseqs2/linclust for Prokka and PLASS annot

module load devtools/python/2.7.12
module load software/bioinformatics/hmmer/3.1b2
module load software/bioinformatics/spades/3.10.1
module load software/bioinformatics/prokka/1.0
module load devtools/bioconda/bioconda3
source activate mmseqs2_env
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/PLASSseqs/PLASS

mmseqs easy-linclust prokka_PLASS_allSamples.faa clusterRes tmp
