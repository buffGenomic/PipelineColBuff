''' This script will iterate along a multifasta file
    and will modify IDs by preceeding them with the 
    name of the sample they come from

    USAGE: sys.argv[0] -i <fastaFile> -o <outputFile>
'''

__author__ = "Juan Jovel [jovel@ualberta.ca]"

import sys
import re
import getopt
from Bio import SeqIO

def main ():
    infile  = ''
    outfile = ''
    length  = ''
    options, remainder = getopt.getopt(sys.argv[1:], 'i:o:', ['infile=',
    'outfile='])

    for opt, arg in options:
        if opt in   ('-i', '--infile'):
            infile = arg
        elif opt in ('-o', '--outfile'):
            outfile = arg

    print 'INFILE       :', infile
    print 'OUTFILE      :', outfile

    try:
        inf = open(infile, "r")
        prefix = re.sub('.faa','', sys.argv[2])
    except:
        sys.stderr.write ("Error, could not open {}".format(sys.argv[2]))
        sys.exit(1)

    try:
        out = open(outfile, "w")
    except:
        sys.exit("Output file could not be open")

    counter = 0
    for record in SeqIO.parse(inf, "fasta"):
        counter += 1
        new_name = prefix + "_" + str(counter)

        record.id = new_name

        SeqIO.write(record, out, "fasta")

    inf.close()
    out.close()

if __name__ == '__main__':
    main()

