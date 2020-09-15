#!/bin/bash 

kraken2_location=/share/lemaylab-backedup/milklab/programs/kraken2-2.0.9b/kraken2
bracken_location=/share/lemaylab-backedup/milklab/programs/Bracken-2.6.0
db=/share/lemaylab-backedup/databases/kraken2-bact-arch-fungi

dup_outdir=..
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq112/kraken2_ver2
kraken2_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq112/kraken2_ver2

# set an empty string variable to get all the names of samples
names='' 

for file in $dup_outdir/*_R1_paired.fastq
do
	STEM=$(basename "$file" _R1_paired.fastq )
	echo "processing sample $STEM"

	# set names parameter for Bracken
	names+=$STEM
	names+=','

	file2=$trim_outdir/${STEM}_R2_paired.fastq

	#$kraken2_location --db $db --threads 35 --confidence 0.2 \
	#--report $kraken2_outdir/${STEM}_report \
	#--report-zero-counts --paired $file $file2 > $kraken2_outdir/${STEM}_kraken2.out 

	# Run Bracken for Abundance Estimation
	python2 $bracken_location/src/est_abundance.py -i $kraken2_outdir/${STEM}_report -k $db/database151mers.kmer_distrib -l G -t 10 -o $kraken2_outdir/${STEM}_genus_abundance.tsv

done

# delete the last "," 
names=${names::-1}

# combine all the Bracken output files to a single file
python2 $bracken_location/analysis_scripts/combine_bracken_outputs_re.py --names $names --output $kraken2_outdir/merged_genus_abundance.tsv --files $kraken2_outdir/*_genus_abundance.tsv

echo "KRAKEN2 DONE AT: "; date
