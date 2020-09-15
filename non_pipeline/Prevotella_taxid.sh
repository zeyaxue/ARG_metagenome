#!/bin/bash 

kraken2_location=/software/kraken2-2.0.9b/kraken2
bracken_location=/software/kraken2-2.0.9b/Bracken-2.6.0
db=/database/kraken2-bact-arch-fungi

dup_outdir=/home/AMR_metagenome/processed_data/Novaseq_072rerun/step3_fastuniq
mtp_outdir=/home/AMR_metagenome/processed_data/Novaseq_072rerun/metaphlan2
kraken2_outdir=/home/AMR_metagenome/processed_data/Novaseq_072rerun/kraken2

for file in $dup_outdir/6093_R1_paired.fastq
do 
	STEM=$(basename "$file" _R1_paired.fastq)

	#bzip2 -dk $mtp_outdir/${STEM}.bowtie2.bz2 

	#grep "k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Prevotellaceae|g__Prevotella|s__Prevotella_copri" /software/metaphlan2-2.8/metaphlan_databases/mpa_v20_m200_marker_info.txt | cut -f1 -d ':' | grep -f - $mtp_outdir/${STEM}.bowtie2 | cut -f1 -d$'\t' | cut -f1 -d '_' > $dup_outdir/${STEM}.P.copri_seqid2 

	#/software/bbmap-37.68/filterbyname.sh in=$dup_outdir/${STEM}_R1_dup.fastq in2=$dup_outdir/${STEM}_R2_dup.fastq out=$dup_outdir/${STEM}_R1_pcopri.fastq out2=$dup_outdir/${STEM}_R2_pcopri.fastq names=$dup_outdir/${STEM}.P.copri_seqid2 include=true
 
 	$kraken2_location --db $db --threads 35 --confidence 0 --report $kraken2_outdir/${STEM}.P.copri_report --paired $dup_outdir/${STEM}_R1_pcopri.fastq $dup_outdir/${STEM}_R2_pcopri.fastq > $kraken2_outdir/${STEM}.P.copri_kraken2.out
done	


for file in $dup_outdir/8013_R1_paired.fastq
do 
	STEM=$(basename "$file" _R1_paired.fastq)

	#bzip2 -dk $mtp_outdir/${STEM}.bowtie2.bz2 

	#grep "k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Prevotellaceae|g__Prevotella|s__Prevotella_copri" /software/metaphlan2-2.8/metaphlan_databases/mpa_v20_m200_marker_info.txt | cut -f1 -d ':' | grep -f - $mtp_outdir/${STEM}.bowtie2 | cut -f1 -d$'\t' | cut -f1 -d '_' > $dup_outdir/${STEM}.P.copri_seqid2 

	#/software/bbmap-37.68/filterbyname.sh in=$dup_outdir/${STEM}_R1_dup.fastq in2=$dup_outdir/${STEM}_R2_dup.fastq out=$dup_outdir/${STEM}_R1_pcopri.fastq out2=$dup_outdir/${STEM}_R2_pcopri.fastq names=$dup_outdir/${STEM}.P.copri_seqid2 include=true
 
 	$kraken2_location --db $db --threads 35 --confidence 0 --report $kraken2_outdir/${STEM}.P.copri_report --paired $dup_outdir/${STEM}_R1_pcopri.fastq $dup_outdir/${STEM}_R2_pcopri.fastq > $kraken2_outdir/${STEM}.P.copri_kraken2.out
done	


for file in $dup_outdir/8024_R1_paired.fastq
do 
	STEM=$(basename "$file" _R1_paired.fastq)

	#bzip2 -dk $mtp_outdir/${STEM}.bowtie2.bz2 

	#grep "k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Prevotellaceae|g__Prevotella|s__Prevotella_copri" /software/metaphlan2-2.8/metaphlan_databases/mpa_v20_m200_marker_info.txt | cut -f1 -d ':' | grep -f - $mtp_outdir/${STEM}.bowtie2 | cut -f1 -d$'\t' | cut -f1 -d '_' > $dup_outdir/${STEM}.P.copri_seqid2 

	#/software/bbmap-37.68/filterbyname.sh in=$dup_outdir/${STEM}_R1_dup.fastq in2=$dup_outdir/${STEM}_R2_dup.fastq out=$dup_outdir/${STEM}_R1_pcopri.fastq out2=$dup_outdir/${STEM}_R2_pcopri.fastq names=$dup_outdir/${STEM}.P.copri_seqid2 include=true
 
 	$kraken2_location --db $db --threads 35 --confidence 0 --report $kraken2_outdir/${STEM}.P.copri_report --paired $dup_outdir/${STEM}_R1_pcopri.fastq $dup_outdir/${STEM}_R2_pcopri.fastq > $kraken2_outdir/${STEM}.P.copri_kraken2.out
done	


