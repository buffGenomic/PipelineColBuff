#!/bin/bash
#SBATCH --job-name=diamond
#SBATCH -D . # Directorio del trabajo
#SBATCH -o PROK_data_%j.out # archivo de salida estandar
#SBATCH -e PROK_data_%j.err # archivo de salida de error
#SBATCH -J ProkkaP # nombre del trabajo
#SBATCH -n 32 # numero de cores a solicitar
#SBATCH -N 2 # numero de nodos a solicitar
# Script for diamond blastp with rumiref

module load software/bioinformatics/hmmer/3.1b2
module load software/bioinformatics/spades/3.10.1
module load software/bioinformatics/prokka/1.0
module load software/bioinformatics/diamond/0.8.17
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/PLASSseqs/PLASSind/DiamondAl

diamond blastp -d rumiref100.dmnd -q clusterRes_rep_seq.fasta --threads 12 -o clusterRes_rep_seq-rumiref100.out
