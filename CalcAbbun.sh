#!/bin/bash
for FILE in *abundance.tsv; do awk '{for (i=2;i<=NF;i++){ sums[i]+=$i;maxi=i}} END {for(i=2;i<=maxi;i++){printf("%s ", sums[i]/(NR-1))}print "\t"}' $FILE > ${FILE/.tsv/_mean.tsv}; done
