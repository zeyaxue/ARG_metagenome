#!/bin/bash

read -p "Enter input directory: " indir

for file in $indir/*fsa
do 
	/share/lemaylab-backedup/Zeya/scripts/gitSRC/ARG_metagenome/count_fasta_length.sh  $file $indir/gene_length.txt
done
