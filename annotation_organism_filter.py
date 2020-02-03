#! /usr/bin/env python

import csv
import argparse

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Generate a list of organisms.')
	parser.add_argument('input', help='file containing the anotation result ')
	parser.add_argument('organism_list', help='file containing the organism list')
	parser.add_argument('identity', help='identity percent filtering from above')
	parser.add_argument('output', help = 'Name and path of result.')
	args = parser.parse_args()
	fileList=open(args.output,"w")
	fileList.write("organism\n")
	identityP=float(args.identity)
	with open(args.input, 'r') as csvfile:
		anotation = csv.reader(csvfile, delimiter='\t')
		next(anotation, None)
		for row in anotation:
			if(row[2]!="No_sig_nr_hit" and row[7]!="No_%_identity"):
				if(float(row[7])>=identityP):
					with open(args.organism_list, 'r') as organism_file:
						for line in organism_file:
							if(row[2].find(line.rstrip('\n'))!=-1):
								fileList.write(line)
	fileList.close()
