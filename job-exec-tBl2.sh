#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -D . # Directorio del trabajo
#SBATCH -o TBLSPAslurm_data_%j.out # archivo de salida estandar
#SBATCH -e TBLSPAslurm_data_%j.err # archivo de salida de error
#SBATCH -J ProkkaP # nombre del trabajo
#SBATCH -n 32 # numero de cores a solicitar
#SBATCH -N 2 # numero de nodos a solicitar
# Script for tblastn used by Prokka

module load devtools/python/2.7.12
module load software/bioinformatics/hmmer/3.1b2
module load software/bioinformatics/spades/3.10.1
module load software/bioinformatics/prokka/1.0
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/

tbl2asn -V b -a r10k -l paired-ends -M b -N 1 -y 'Annotated using prokka 1.12 from https://github.com/tseemann/prokka' -Z scaffolds\.fasta1\/scaffolds\.fasta1\.err -i scaffolds\.fasta1\/scaffolds\.fasta1\.fsa 2> /dev/null
