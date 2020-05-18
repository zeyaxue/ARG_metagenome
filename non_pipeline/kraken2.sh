#!/bin/bash 

kraken2_location=/software/kraken2-2.0.9b/kraken2
db=/database/kraken2-bact-arch-fungi

dup_outdir=/home/AMR_metagenome/processed_data/Novaseq_072rerun/step3_fastuniq
mkdir /home/AMR_metagenome/processed_data/Novaseq_072rerun/kraken2
kraken2_outdir=/home/AMR_metagenome/processed_data/Novaseq_072rerun/kraken2

for file in $dup_outdir/*_R1_dup.fastq
do
	STEM=$(basename "$file" _R1_dup.fastq)
	echo "processing sample $STEM"

	file2=$dup_outdir/${STEM}_R2_dup.fastq

	$kraken2_location --db $db --threads 35 --classified-out $kraken2_outdir/${STEM}_classified-out#.fq --unclassified-out $kraken2_outdir/${STEM}_unclassified-out#.fq --report $kraken2_outdir/${STEM}_report --report-zero-counts --paired $file $file2 > $kraken2_outdir/${STEM}_kraken2.out 

done

echo "KRAKEN2 DONE AT: "; date
