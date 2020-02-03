#!/bin/bash
# Shell script for filter only annotation headers
export set PATH=$PATH:/BIOS-Share/home/saguilar/Data/TrimmedOutputs/HSeqs/

for d in *Scaff; do grep ">" $d/Filter.faa > $d/HeaderFilter.faa; done

