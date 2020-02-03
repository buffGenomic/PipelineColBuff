find . -name '*R2*fastq' -exec bash -c ' mv $0 ${0/\_R2/R2}' {} \;
