#!/usr/bin/env python3

import sys


def main(MASK_FILE: str):
    """
       Take a mask file containing positions below a certain
       depth, and convert it to BED format:

       Mask:
       genome.1    1
       genome.1    2
       genome.1    3
       genome.1    4
       genome.1    100

       BED:
       genome.1    1    4
       genome.1    100  100
    """
    BED_FILE = str('mask.bed')
    mask_data = open(MASK_FILE, 'r')
    INIT_POS = None
    END_POS = None
    for record in mask_data:
        record = record.strip('\n')
        CHR, POS = record.split('\t')
        if INIT_POS is None:
            INIT_POS = POS
        else:
            if int(POS) - 1 == int(PREV_POS):
                END_POS = POS
            else:
                if END_POS is not None:
                    with open(BED_FILE, 'a') as fOut:
                        fOut.write(CHR + '\t' + INIT_POS + '\t' + END_POS + '\n')
                INIT_POS = END_POS = POS
       
        # Keep track of the past
        PREV_POS = POS
       

if __name__ == "__main__":
    # argv[1] == mask file
    main(sys.argv[1])
