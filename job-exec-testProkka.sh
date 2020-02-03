#!/bin/bash
#SBATCH --job-name=fastqc
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
module load software/bioinformatics/prokka/1.0
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/

for FILE in scaffolds.fasta; do prokka --cpus 24 --centre X --compliant --outdir ${FILE/_metaspades*/_prokka}1 --prefix ${FILE/_metaspades*/} $FILE; done
