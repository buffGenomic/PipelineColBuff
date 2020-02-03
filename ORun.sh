#!/bin/bash
for FILE in 1test.tsv; do awk '{for (i=1;i<=NF;i++){sum[i]+=$i;}} END {for (i in sum) {for (j=1;j<=NF;j++){printf("%s", $j);printf "\t";}print  "\t";}}' $FILE > ${FILE/.tsv/_output.tsv}; done
