#!/bin/bash

########################################################################################################################
#
# STEP 10. ID the taxonomy of contigs using taxator-tk 

echo "NOW STARTING TAXONOMY ID AT: "; date

# set input and output file paths
aln_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step9_contig_bwa
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_CAT
CAT_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_CAT
cd $CAT_outdir 

# Make sure bash knows where to look for softwares 
CAT=/share/lemaylab-backedup/milklab/programs/CAT-5.0.3/CAT_pack/CAT
progdigal=/software/prodigal/2.6.3/x86_64-linux-ubuntu14.04/bin/prodigal 
diamond=/share/lemaylab-backedup/milklab/programs/diamond


for file in $aln_outdir/*_contig_aln.fasta
do
	STEM=$(basename "$file" _contig_aln.fasta)

	echo "Processing sample $STEM now...... "
	# for help /share/lemaylab-backedup/milklab/programs/CAT-5.0.3/CAT_pack/CAT contigs -h
	# https://github.com/dutilh/CAT

	$CAT contigs -c $file -d /share/lemaylab-backedup/milklab/database/CAT_prepare_20190719/2019-07-19_CAT_database -t /share/lemaylab-backedup/milklab/database/CAT_prepare_20190719/2019-07-19_taxonomy --path_to_prodigal $progdigal --path_to_diamond $diamond -o $CAT_outdir/${STEM}_CAT -n 25

	$CAT add_names -i $CAT_outdir/${STEM}_CAT.contig2classification.txt -o $CAT_outdir/${STEM}.taxaid.txt -t /share/lemaylab-backedup/milklab/database/CAT_prepare_20190719/2019-07-19_taxonomy --only_official

	$CAT summarise -c $file -i $CAT_outdir/${STEM}.taxaid.txt -o $CAT_outdir/${STEM}.taxaname.txt
done	

echo "STEP 10 DONE AT: "; date