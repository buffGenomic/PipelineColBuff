#!/usr/bin/env python

from Bio import SeqIO
import numpy, argparse, csv, sys


def N50(numlist):
    """
    Abstract: Returns the N50 value of the passed list of numbers.
    Usage:    N50(numlist)

    Based on the Broad Institute definition:
    https://www.broad.harvard.edu/crd/wiki/index.php/N50
    """
    numlist.sort()
    newlist = []
    for x in numlist :
        newlist += [x]*x
    # take the mean of the two middle elements if there are an even number
    # of elements.  otherwise, take the middle element
    if len(newlist) % 2 == 0:
        medianpos = len(newlist)/2
        return float(newlist[medianpos] + newlist[medianpos-1]) /2
    else:
        medianpos = len(newlist)/2
        return newlist[medianpos]


if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Generate n50 list of 3 assemblies')
	parser.add_argument('assembly_1', help='fasta file containing the contigs for analysis.')
	parser.add_argument('assembly_2', help='fasta file containing the contigs for analysis.')
	parser.add_argument('assembly_3', help='fasta file containing the contigs for analysis.')
	parser.add_argument('assemblerName_1', help='Name of the used Assembler')
	parser.add_argument('assemblerName_2', help='Name of the used Assembler')
	parser.add_argument('assemblerName_3', help='Name of the used Assembler')
	parser.add_argument('output', help='path of output')
	args = parser.parse_args()
	with open(args.assembly_1, 'r') as seq:
		sizes = [len(record) for record in SeqIO.parse(seq, 'fasta')]
	with open(args.assembly_2, 'r') as seq:
		sizes2 = [len(record) for record in SeqIO.parse(seq, 'fasta')]
	with open(args.assembly_3, 'r') as seq:
		sizes3 = [len(record) for record in SeqIO.parse(seq, 'fasta')]
	ofile=open(args.output, "wb")
	ofile.write("n50\tassembler\n")
	ofile.write(str(N50(sizes))+"\t"+args.assemblerName_1+"\n")
	ofile.write(str(N50(sizes2))+"\t"+args.assemblerName_2+"\n")
	ofile.write(str(N50(sizes3))+"\t"+args.assemblerName_3+"\n")
	ofile.close()
	
	
