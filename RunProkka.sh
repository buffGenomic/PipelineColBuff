#!/bin/bash
for FILE in scaffolds.fasta; do prokka --cpus 24 --centre X --compliant --outdir ${FILE/_metaspades*/_prokka}1 --prefix ${FILE/_metaspades*/} $FILE; done
