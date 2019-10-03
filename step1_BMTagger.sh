## Based on script from https://github.com/mltreiber/functional_metagenomics/blob/master/scripts/master_beta.galac.db_analysis_stoolmg.sh

# To have the process run in the background even if ssh connection is interupted, I used the GNU screen 
# To start a new window: 

# Alternatively SBATCH COMMAND CAN BE used to manage running the work

##########################################################################
#
# VARIABLES - set these paths for each step.
#
#       0. Starting and output files location
starting_files_location=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/unzipped

mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output/
output_files_location=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step_1_BMTagger_output

#       1. Human Read Removal
bmtagger_location=/share/lemaylab-backedup/milklab/programs/bmtools/bmtagger
# bbmap_location=/path/to/Programs/BBMap/sh 
# 9/25/19 I can't find BBMap...Will dig for it later
human_db=/share/lemaylab-backedup/milklab/database/human_GRCh38_p13

#       2. PEAR
#pear_location=/path/to/Programs/pear-0.9.6/pear-0.9.6

#       3. Trimmomatic
#trimmomatic_location=/path/to/Programs/Trimmomatic-0.33/trimmomatic-0.33.jar

#       4. DIAMOND 
#b_galac_database="/path/to/protein_dbs/db_with_B-galac.dmnd"
#diamond_location="/path/to/Programs"

#       5. Aggregation
#programs=/path/to/stool_metagenomes/Code
#B_galac_db="/path/to/golden_databases/protein_dbs/db_with_B-galac.faa"

####################################################################

###################################################################
#
# STEP 1: REMOVING HUMAN READS USING BMTAGGER
# Note: paired-end files are usually named using R1 and R2 in the name.
# Note: if using single-end reads, only need to specify one input flag (-1)

PATH=$PATH:/share/lemaylab-backedup/milklab/programs/bmtools/bmtagger
PATH=$PATH:/share/lemaylab-backedup/milklab/programs/srprism/gnuac/app
module load blast
module load java bbmap
echo "NOW STARTING HUMAN READ REMOVAL STEP AT: "; date

for file in $starting_files_location/*R1_001.fastq

do
        file1=$file
        file2=$(echo $file1 | sed 's/R1_001/R2_001/')
		filename=$(basename "$file1")
        basename=$(echo $filename | cut -f 1 -d "_")
		outname="$output_files_location/$basename"

        $bmtagger_location/bmtagger.sh -b $human_db/GCF_000001405.39_GRCh38.p13_genomic.bitmask -x $human_db/GCF_000001405.39_GRCh38.p13_genomic.srprism -q 1 -1 $file1 -2 $file2 -o $outname.human.txt

        # filterbyname.sh is included in the bbmap module
        # Here I used the local copiy of the filterbyname.sh to as a stable copy 
        # This script removes sequences in both R1 and R2 that matches the human reads 
        # (sequence header is passed to the script in the outname.human.txt file)
        /share/lemaylab-backedup/milklab/programs/filterbyname_v37.68.sh in=$file1 in2=$file2 out=$outname.R1_nohuman.fastq out2=$outname.R2_nohuman.fastq names=$outname.human.txt include=f
done

echo "STEP 1 DONE AT: "; date

####################################################################