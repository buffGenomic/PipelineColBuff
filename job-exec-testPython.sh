#!/bin/bash
#SBATCH -D . # Directorio del trabajo
#SBATCH -o slurm_data.out # archivo de salida estandar
#SBATCH -e slurm_data.err # archivo de salida de error
#SBATCH -J datamining # nombre del trabajo
#SBATCH -n 1 # numero de cores a solicitar
#SBATCH -N 1 # numero de nodos a solicitar

module load devtools/python/2.7.12 
for i in 1000 5000 10000 20000
do
  python test.py $i
  echo "I finished the test with $i meters!"
done
