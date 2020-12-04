#!/bin/bash

########################################################################################################################
#
# STEP 10. ID the taxonomy of contigs using Contig Annotation Tool (CAT)

echo "NOW STARTING TAXONOMY ID AT: "; date

run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043

# set input and output file paths
aln_outdir=$run_dir/step9_contig_bwa_nomerg
mkdir $run_dir/step10_CAT_nomerg
CAT_outdir=$run_dir/step10_CAT_nomerg
cd $CAT_outdir 

# Make sure bash knows where to look for softwares 
CAT=/share/lemaylab-backedup/milklab/programs/CAT-5.0.3/CAT_pack/CAT
CAT_db=/share/lemaylab-backedup/databases/CAT_prepare_20200618
#progdigal=/software/prodigal/2.6.3/x86_64-linux-ubuntu14.04/bin/prodigal 
diamond=/share/lemaylab-backedup/milklab/programs/diamond-0.9.34/diamond

for file in $aln_outdir/*_contig_ARGread_aln_mappedonly.fa
do
	STEM=$(basename "$file" _contig_ARGread_aln_mappedonly.fa)

	echo "Processing sample $STEM now...... "
	# for help /share/lemaylab-backedup/milklab/programs/CAT-5.0.3/CAT_pack/CAT contigs -h
	# https://github.com/dutilh/CAT

	#$CAT contigs -c $file -d $CAT_db/2020-06-18_CAT_database -t $CAT_db/2020-06-18_taxonomy --path_to_prodigal $progdigal --path_to_diamond $diamond -o $CAT_outdir/${STEM}_CAT -n 25
	$CAT contigs -c $file -d $CAT_db/2020-06-18_CAT_database -t $CAT_db/2020-06-18_taxonomy -p ${STEM}_CAT.predicted_proteins.faa --path_to_diamond $diamond -o $CAT_outdir/${STEM}_CAT -n 25

	$CAT add_names -i $CAT_outdir/${STEM}_CAT.contig2classification.txt -o $CAT_outdir/${STEM}.taxaid.txt -t $CAT_db/2020-06-18_taxonomy --only_official

	$CAT summarise -c $file -i $CAT_outdir/${STEM}.taxaid.txt -o $CAT_outdir/${STEM}.taxaname.txt
done	

echo "STEP 10 DONE AT: "; date