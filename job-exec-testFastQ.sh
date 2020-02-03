#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -D . # Directorio del trabajo
#SBATCH -o slurm_data_%j.out # archivo de salida estandar
#SBATCH -e slurm_data_%j.err # archivo de salida de error
#SBATCH -J fastqcP # nombre del trabajo
#SBATCH -n 32 # numero de cores a solicitar
#SBATCH -N 2 # numero de nodos a solicitar
# Shell for fastqc to all seqs

module load software/bioinformatics/fastqc/0.11.4
for i in ./TrimmedOutputs/*.fastq
do
	fastqc -o ./outputs $i 
done
