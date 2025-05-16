#!/usr/bin/env python3

from Bio import SeqIO
import sys


def makeBED(reference: str):
    fasta = SeqIO.parse(reference, 'fasta')
    with open('reference.bed', 'w') as fOut:
        for record in fasta:
            fOut.write(f"{record.id}\t0\t{len(record.seq)}\n")
    return

if __name__ == '__main__':
    # argv[1]: reference FASTA sequence
    makeBED(sys.argv[1])
