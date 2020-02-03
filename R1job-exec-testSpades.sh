#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -D . # Directorio del trabajo
#SBATCH -o SPAslurm_data_%j.out # archivo de salida estandar
#SBATCH -e SPAslurm_data_%j.err # archivo de salida de error
#SBATCH -J fastqcP # nombre del trabajo
#SBATCH -n 64 # numero de cores a solicitar
#SBATCH -N 1 # numero de nodos a solicitar
#SBATCH --partition=bigmemory

module load devtools/python/2.7.12
module load software/bioinformatics/hmmer/3.1b2
module load software/bioinformatics/spades/3.10.1
for FILE in $(ls *R1.fastq | sed 's/_R1.fastq//'); do metaspades.py -s ${FILE}_R1.fastq -o ${FILE}; done
