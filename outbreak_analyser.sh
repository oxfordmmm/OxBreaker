#!/bin/bash

export QT_QPA_PLATFORM=offscreen

DIR=/home/carlos/projects/outbreaks/JRH/c_diff
echo "Processing ${DIR}..."

# Run outbreak analyser
nextflow run main.nf $1 \
-profile standard -resume \
-entry outbreaker \
--input $DIR/runs_merged \
--output $DIR/output \
--db /home/carlos/projects/dbs/kraken/microbial/ #\
#--reference /home/carlos/projects/references/cdiff_630_chr.fa

echo "Done."
