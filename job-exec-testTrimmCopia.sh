#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -D . # Directorio del trabajo
#SBATCH -o Tslurm_data_%j.out # archivo de salida estandar
#SBATCH -e Tslurm_data_%j.err # archivo de salida de error
#SBATCH -J fastqcP # nombre del trabajo
#SBATCH -n 32 # numero de cores a solicitar
#SBATCH -N 2 # numero de nodos a solicitar

module load software/bioinformatics/fastqc/0.11.4
export set PATH=$PATH:/BIOS-Share/home/saguilar/Tools/ea-utils/clipper/
for i in ./tempData1/*.fastq
do
        f="$(basename -- $i)"
	fastq-mcf adapters.fa -o ${f}_trim20.fastq $i -k 0 -l 120 -w 3 -q 20
done
