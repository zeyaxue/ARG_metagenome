#!/bin/bash

########################################################################################################################
#
# STEP 10. ID the taxonomy of contigs using BBsketch 

echo "NOW STARTING TAXONOMY ID AT: "; date

aln_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step9_contig_bwa
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_bbsketch
taxaid_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_bbsketch

# Make sure bash knows where to look for softwares 

bbmap=/software/bbmap/37.68/static/

for file in $aln_outdir/*_contig_aln.fasta
do
	STEM=$(basename "$file" _contig_aln.fasta)

	echo "Processing sample $file now...... "

	# pass -h to get help manual
	$bbmap/sendsketch.sh in=$file out=taxaid_outdir/${STEM}_taxaid.txt refseq
done	

echo "STEP 10 DONE AT: "; date
