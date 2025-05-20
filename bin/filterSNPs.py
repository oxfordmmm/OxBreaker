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


def is_pileup(record) -> bool:
    """
    Determine if current VCF record comes from the alignment (F) or pileup (P).
    !!!!!_ONLY WORKS WITH CLAIR3_!!!!
    """
    PILEUP_ID = 7
    tmp_record = record.decode().split('\t')
    return bool(tmp_record[PILEUP_ID] == str('P'))


def is_above_minFreq(record, MIN_FREQ) -> bool:
    """
        Determine whether a record is above the minimum frequency
        set in the pipeline
    """
    META_ID = -1
    FREQ_ID = -1
    tmp_record = record.decode().strip('\n').split('\t')
    freq_info = tmp_record[META_ID].split(':')
    af_freq = float(freq_info[FREQ_ID])
    return bool(af_freq >= float(MIN_FREQ))


def main(vcf_file: str, min_freq: str):
    fOut = vcf_file.replace('.vcf.gz', '_filtered.vcf.gz')
    indel = 0
    align = 0
    freq = 0
    with gzip.open(fOut, 'w') as filtered:
        with gzip.open(vcf_file, 'r') as variants:
            for record in variants:
                if record.decode()[0] == str('#'):
                    # Write header as-is
                    filtered.write(record)
                else:
                    # Check indels
                    if is_snp(record) and is_pileup(record) and \
                            is_above_minFreq(record, min_freq):
                        filtered.write(record)
                    elif is_snp(record) and is_pileup(record) and \
                            not is_above_minFreq(record, min_freq):
                        freq += 1
                    elif is_snp(record) and not is_pileup(record):
                        align += 1
                    else:
                        indel += 1

    print("[" + str(indel+align+freq) + " variants filtered] '" + str(indel) + "' INDELs, '" + str(align) +
          "' variants found by alignment only, and '" + str(freq) + "' variants below MIN_FREQ.\n")
    return


if __name__ == '__main__':
    # argv[1]: reference vcf.gz sequence
    # argv[2]: min allele frequency
    main(sys.argv[1], sys.argv[2])
