#!/bin/bash

########################################################################################################################


########################################################################################################################
#
# STEP 0. UNZIPPED RAW READ FILES 

#echo "NOW STARTING UNZIPPING AT: "; date
#
## set input and output file paths
#raw_indir=/share/lemaylab-backedup/Zeya/raw_data/NovaSeq043/tb957t8xg/Un_DTDB73/Project_DLZA_Nova043P_Alkan
#unzip_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/unzipped
#
## for loop to unzip all gz file to fastq in one file 
#for file in $raw_indir/*fastq.gz
#do
#	STEM=$(basename "${file}" .gz)
#
#	if [ -f $unzip_outdir/"${STEM}" ]
#	then 
#		echo $unzip_outdir/"${STEM}".fastq already exist and will not be overwritten.
#	else
#		echo "${STEM}" does not exist. Unzipping now....		
#		gunzip -c "${file}" > $unzip_outdir/"${STEM}"
#  	fi		
#done
#
#echo "STEP 0 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 1: REMOVING HUMAN READS USING BMTAGGER
# Note: paired-end files are usually named using R1 and R2 in the name.
# Note: if using single-end reads, only need to specify one input flag (-1)

#echo "NOW STARTING HUMAN READ REMOVAL STEP AT: "; date

## Set input and output file paths
#human_db=/share/lemaylab-backedup/milklab/database/human_GRCh38_p13
#mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output
bmtagger_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output
#
## Make sure bash knows where to look for softwares 
#PATH=$PATH:/share/lemaylab-backedup/milklab/programs/bmtools/bmtagger
#PATH=$PATH:/share/lemaylab-backedup/milklab/programs/srprism/gnuac/app
#module load blast
#module load java bbmap
#bmtagger=/share/lemaylab-backedup/milklab/programs/bmtools/bmtagger/bmtagger.sh
#
#for file in $unzip_outdir/*R1_001.fastq
#do
#	filename=$(basename "$file1")
#   STEM=$(echo $filename | cut -f 1 -d "_") # keep only the first field parsed by separator "_"
#
#	file1=$file
#   file2=$(echo $file1 | sed 's/R1_001/R2_001/')
#
#	outname="$bmtagger_outdir/$basename"
#
#    if [ -f $outname.human.txt ]
#    then 
#        echo $outname.human.txt already exist and will not be overwritten.
#    else
#        echo $outname.human.txt does not exist. Running BMTagger now...
#        $bmtagger -b $human_db/GCF_000001405.39_GRCh38.p13_genomic.bitmask \
#        -x $human_db/GCF_000001405.39_GRCh38.p13_genomic.srprism \
#        -q 1 -1 $file1 -2 $file2 -o $outname.human.txt
#
#        # filterbyname.sh is included in the bbmap module 
#        # bbmap module location: /software/bbmap/37.68/static/bbmap.sh
#        # I included a local copy of this program: /share/lemaylab-backedup/milklab/programs/filterbyname_v37.68.sh
#        # This script removes sequences in both R1 and R2 that matches the human reads 
#        # (sequence header is passed to the script in the outname.human.txt file)
#        filterbyname.sh in=$file1 in2=$file2 \
#        out=$outname.R1_nohuman.fastq out2=$outname.R2_nohuman.fastq \
#        names=$outname.human.txt include=f
#    fi
#done
#
#echo "STEP 1 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 2: USE TRIMMOMATIC TO REMOVE LOW-QUALITY READS
# Take input from BMTagger (removal of the human DNA)
# Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere) and using the paired end mode 
# from link: http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf

echo "NOW STARTING READ CLEANING WITH TRIMMOMATIC AT: "; date 

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2_trim/ 
trim_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step2_trim

# Make sure bash knows where to look for softwares 
trimmomatic_dir=/share/lemaylab-backedup/milklab/programs/

for file in $bmtagger_outdir/*.R1_nohuman.fastq 
do
	STEM=$(basename "$file" .R1_nohuman.fastq)

	file1=$file
	file2=$bmtagger_outdir/${STEM}.R2_nohuman.fastq
	
	# remove adapter and trimming at the same time (TrueSeq3-PE-2.fa, PE1_rc and PE2_rc)
	java -jar $trimmomatic_dir/trimmomatic-0.39-1.jar PE -threads 5 -trimlog \
	$trim_outdir/trimmomatic_log.txt \
	$file1 $file2 \
	$trim_outdir/${STEM}_R1_paired.fastq \
	$trim_outdir/${STEM}_R1_unpaired.fastq.gz \
	$trim_outdir/${STEM}_R2_paired.fastq \
	$trim_outdir/${STEM}_R2_unpaired.fastq.gz \
	-phred33 \
	ILLUMINACLIP:$trimmomatic_dir/trimmomatic_adapter_input.fa:2:30:10 \
	SLIDINGWINDOW:4:15 MINLEN:99
done

echo "STEP 2 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 3: Remove duplicated reads with FastUniq software

echo "NOW STARTING REMOVING DUPLICATE READS AT: "; date 

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step3_fastuniq
dup_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step3_fastuniq

# Make sure bash knows where to look for softwares 
fastuniq=/share/lemaylab-backedup/milklab/programs/fastuniq-1.1-h470a237_1/bin/fastuniq

# Create input file needed to run fastuniq
touch $dup_outdir/fastuniq_input_list.txt
fastuniq_input_list=$dup_outdir/fastuniq_input_list.txt

for file in $trim_outdir/*_R1_paired.fastq
do 
	# clear the content of the list file so that FastUniq takes only 2 files every time it runs
	> $fastuniq_input_list

	STEM=$(basename "$file" _R1_paired.fastq)

	file1=$file
	file2=$trim_outdir/${STEM}_R2_paired.fastq

	# Add file names to the fastuniq input list
	echo $file1 >> $fastuniq_input_list
	echo $file2 >> $fastuniq_input_list

	# Although FastUniq takes list as input !!!!DO NOT SUPPLY ALL FILES IN ONE LIST!!!!
	# Because FastUniq can only write out 2 files for forward and reverse
	# Run FastUniq
	# For FastUniq options: https://wiki.gacrc.uga.edu/wiki/FastUniq
	$fastuniq -i $fastuniq_input_list -t q \
	-o $dup_outdir/${STEM}_R1_dup.fastq \
	-p $dup_outdir/${STEM}_R2_dup.fastq
done

echo "STEP 3 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 4: Merge paired-end reads with FLASH

echo "NOW STARTING PAIRED-END MERGING WITH FLASH AT: "; date

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step4_flash
flash_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step4_flash

# Make sure bash knows where to look for softwares 
flash=/share/lemaylab-backedup/milklab/programs/FLASH-1.2.11_2019/FLASH-1.2.11-Linux-x86_64/flash

for file in $dup_outdir/*_R1_dup.fastq
do
	STEM=$(basename "$file" _R1_dup.fastq)

	file1=$file
	file2=$dup_outdir/${STEM}_R2_dup.fastq
	
	# The FLASH manual link: http://ccb.jhu.edu/software/FLASH/MANUAL
	# -m: minium overlap length 10bp to be similar to pear 
	# -M: max overlap length 
	# -x: mismatch ratio, default is 0.25, which is quite high (e.g: 50bp overlap --> 12.5 mismatch by default)
	$flash $file1 $file2 -m 10 -M 100 -x 0.1 -o ${STEM} -d $flash_outdir
done

echo "STEP 4 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 5: Normalize for sample average genome size and RPKG
# The MicrobeCensus help page: https://github.com/snayfach/MicrobeCensus

echo "NOW CALCULATING GENOME EQUIVALENTS PER METAGENOME WITH MICROBECENSUS AT: "; date

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step5_MicrobeCensus
mc_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step5_MicrobeCensus

# Make sure bash knows where to look for softwares 
microbecensus=/share/lemaylab-backedup/milklab/programs/MicrobeCensus-1.1.1/microbe_census/bin/run_microbe_census.py 

# change dir for writing temporary files
export TMPDIR=$mc_outdir
# Add the numpy/python path to $PATH
export PATH="/home/xzyao/.local/bin:$PATH"

for file in $flash_outdir/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

	# -h for help
	# -t thread number
	$microbecensus $file $mc_outdir/${STEM}_mc.txt -t 15
done

echo "STEP 5 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 6: Align to MEGARes database with bwa

echo "NOW STARTING ALIGNMENT TO MEGARES_v2 WITH BWA AT: "; date

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa
megares_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step6_megares_bwa
# megares db including both drug, metal and biocide resistance genes
megares_dir=/share/lemaylab-backedup/milklab/database/megares_v2/

# Make sure bash knows where to look for softwares 
# Location and version of bwa module: /software/bwa/0.7.16a/lssc0-linux/bwa
module load bwa 

for file in $flash_outdir/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq) 

	# use the bwa mem method for fastest speed and accuracy
	# BWA aligner manual: http://bio-bwa.sourceforge.net/bwa.shtml
	# -t: thread
	bwa mem -t 7 $megares_dir/megares_modified_database_v2.00.fasta $file > $megares_outdir/${STEM}_align.sam
done

echo "STEP 6 DONE AT: "; date
########################################################################################################################


########################################################################################################################
#
# STEP 7. Count the MEGARes database alignment and normalize the count table with MicrobeCensus generated 
# genome equivalents per sample

echo "NOW MAKING COUNT TABLE AT: "; date

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/resistomeanalyzer_output
ra_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/resistomeanalyzer_output

# Make sure bash knows where to look for softwares 
ranalyzer=/share/lemaylab-backedup/milklab/programs/resistomeanalyzer/resistome

for file in $megares_outdir/*_align.sam
do
	STEM=$(basename "$file" _align.sam)

	# usage instructions: https://github.com/cdeanj/resistomeanalyzer
	$ranalyzer \
	-ref_fp $megares_dir/megares_modified_database_v2.00.fasta \
	-sam_fp $file \
	-annot_fp $megares_dir/megares_modified_annotations_v2.00.csv \
	-gene_fp $ra_outdir/${STEM}_gene.tsv \
	-group_fp $ra_outdir/${STEM}_group.tsv \
	-class_fp $ra_outdir/${STEM}_class.tsv \
	-mech_fp $ra_outdir/${STEM}_mechanism.tsv \
	-t 80 #Threshold to determine gene significance
done	


echo "NOW STARTING COUNT TABLE NORMALIZATION AT: "; date

# Set input and output file paths
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/normalized_tab
norm_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step7_norm_count_tab/normalized_tab

# Make sure bash knows where to look for softwares 
norm=/share/lemaylab-backedup/Zeya/scripts/gitSRC/ARG_metagenome/make_RPKG_normtab.py
# make sure python knows where to look for pkgs
export PATH="/home/xzyao/.local/bin:$PATH"

for file in $ra_outdir/*_gene.tsv
do
	STEM=$(basename "$file" _gene.tsv)

	python $norm \
	--mc $mc_outdir/${STEM}_mc.txt \
	--genelen $megares_dir/megares_modified_database_v2_GeneLen_org.tsv \
	--count $file \
	--out $norm_outdir/${STEM}_norm.tsv \
	--mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument (if using python3, can omit this input)
done	

# use the python script again to merge tables
python $norm \
	--mergeout $norm_outdir/merge_norm_final.tsv \
	--mergein $norm_outdir/*_norm.tsv 


echo "STEP 7 DONE AT: "; date
########################################################################################################################
























