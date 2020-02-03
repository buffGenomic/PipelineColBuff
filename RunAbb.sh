#!/bin/bash
#for FILE in 1test.tsv; do awk '{for (i=1;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) printf(sum[i]);printf "\t";}' $FILE > ${FILE/.tsv/_output.tsv}; done
# Normalize protein annot
for FILE in 1test.tsv; do awk 'NR==FNR{sum+= $1; next}{printf("%4.2f\n", ($1/sum)*1000000)}' $FILE $FILE > ${FILE/.tsv/_output1.tsv}; done
