#!/usr/bin/env python3

import gzip
import sys


def is_snp(record: str) -> bool:
    """
      Determine whether a record is a SNP based on the length of the
      sequence at a given position in the reference genome.
    """
    REF_ID = 3
    ALT_ID = 4
    tmp_record = record.decode().split('\t')
    return bool(len(tmp_record[REF_ID]) == len(tmp_record[ALT_ID]))


def is_pileup(record):
    """
    Determine if current VCF record comes from the alignment (F) or pileup (P).
    !!!!!_ONLY WORKS WITH CLAIR3_!!!!
    """
    PASS_ID = 7
    PASS = False
    tmp_record = record.decode().split('\t')
    if tmp_record[PASS_ID] == str('P'):
        PASS = True
    return PASS


def main(vcf_file: str):
    fOut = vcf_file.replace('.vcf.gz', '_filtered.vcf.gz')
    indel = 0
    align = 0
    with gzip.open(fOut, 'w') as filtered:
        with gzip.open(vcf_file, 'r') as variants:
            for record in variants:
                if record.decode()[0] == str('#'):
                    # Write header as-is
                    filtered.write(record)
                else:
                    # Check indels
                    if is_snp(record) and is_pileup(record):
                        filtered.write(record)
                    elif is_snp(record) and not is_pileup(record):
                        align += 1
                    else:
                        indel += 1

    print("Filtered '" + str(indel) + "' INDELs (of which '" + str(align) +
          "' variants were found by alignment only).\n")
    return


if __name__ == '__main__':
    # argv[1]: reference vcf.gz sequence
    main(sys.argv[1])
