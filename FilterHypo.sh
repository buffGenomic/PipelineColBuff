#!/bin/bash
#Shell script for Filter and Exclude Hypothetical proteins
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/

for d in *Scaff; do awk '/^>/ && toupper($0) ~ /HYPOTHETICAL/ {bool=1}; /^>/ && toupper($0) !~ /HYPOTHETICAL/ {bool=0}; {if (bool==0) print}' $d/scaffolds.fasta1.faa > $d/Filter.faa; done

