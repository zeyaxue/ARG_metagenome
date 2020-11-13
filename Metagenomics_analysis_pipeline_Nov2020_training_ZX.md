# Metagenomics analysis pipeline Nov2020 training ZX

See `/share/lemaylab-backedup/Zeya/Lemay_lab_analysis/flowcharts/Metagenome_pipeline_annotation.pdf` for a high-resolution flowchart image
![](https://i.imgur.com/Mtdi8TH.png)





Initialize the work environment by downloading required python packages, see list here: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_python_packages`. 

Some python packages have to be downloaded in the same directory where your script sits for stability. See `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/README.md` for more info


Raw sequence files are downloaded from the sequencing core server. After the completion of downloading, check for “completeness” of files and make sure none of the downloaded files are corrupted. 
-	Script: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/checksums_bash.sh` 
-	Output: `/share/lemaylab-backedup/Zeya/raw_data/NovaSeq112/checksum_man_112.txt`
-	Compare manually generated with checksums with the checksum file that was downloaded from the sequencing core server to ensure file integrity:
`diff /share/lemaylab-backedup/Zeya/raw_data/NovaSeq112/@md5Sum.md5  /share/lemaylab-backedup/Zeya/raw_data/NovaSeq112/checksum_man_112.txt`


## Step 0: Unzip the raw reads 
- Script: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/gunzip_loop.sh`
- Input directory: Directory containing downloaded raw reads `/share/lemaylab-backedup/Zeya/raw_data/NovaSeq112/` 
- Output directory: This folder has now been removed to save space on spitfire. `$run_dir/unzipped` 

## Step 1: Remove human reads using BMTagger
- Initialization: script used to download and format human_GRCh38_p13 genome version. `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/human_ref_format4BMTagger.sh`
- Script: step 1 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: unzipped files. `$run_dir/unzipped` 
- Output directory: `$run_dir/step1_BMTagger`

When running this step, there will be a warning message: "no ./bmtagger.conf found", which is fine. The `bmtagger.conf` file is not needed because `PATH` to dependencies are specified in the script already. 

## Step 2: Use Trimmomatic to remove low-quality reads
- Script: step 2 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step1_BMTagger`
- Output directory: `$run_dir/step2_trim`


Trimmomatic parameters followed this paper (Taft et al., 2018, mSphere) and using the paired end mode.


This script removes any remaining adapter and trimming at the same time (TrueSeq3-PE-2.fa, PE1_rc and PE2_rc). The input adapter file `/share/lemaylab-backedup/milklab/programs/trimmomatic_adapter_input.fa`  may need to be modified if different library preparation method is used.

Manual: http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf

## Step 3: Remove duplicated reads with FastUniq 
- Script: step 3 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step2_trim`
- Output directory: `$run_dir/step3_fastuniq`

For FastUniq options: https://wiki.gacrc.uga.edu/wiki/FastUniq. I used default parameters

## Step 4: Merge paired-end reads with FLASH
- Script: step 4 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step3_fastuniq`
- Output directory: `$run_dir/step4_flash`

Parameters that need to be specified
-m 10: minium overlap length 10bp to be similar to pear 
-M 100: max overlap length (change depending on library prep)
-x 0.1: mismatch ratio, default is 0.25, which is quite high 

## Step 5: Run MicrobeCensus on paired-end reads to calculate genome equivalents per sample
- Initialization: see `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_MicrobeCensus.sh` for install MicrobeCensus 1.1.1
- Script: step 5 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step3_fastuniq`
- Output directory: `$run_dir/step5_MicrobeCensus`

Parameters that need to be specified
-n 100000000: subsampling read numbers, change per run depending library size. Alternatively, set a large enough number so that all reads are included.

## Step 5: Run MicrobeCensus on merged reads to calculate genome equivalents per sample
- Script: step 5_merged in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step4_flash`
- Output directory: `$run_dir/step5_MicrobeCensus_merged`

Parameters that need to be specified
-n 100000000: subsampling read numbers, change per run depending library size of merged reads. Alternatively, set a large enough number so that all reads are included.

## Step 6: Align to MEGARes database with bwa
- Initialization: see `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_MEGARes_v2.sh` for how to download and organze the MEGARes database
- Script: step 6 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step3_fastuniq`
- Output directory: `$run_dir/step6_megares_bwa`

## STEP 7. Count the MEGARes database alignment and normalize the count 
- Initialization: download resistome analyzer `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_Resistome_Analyzer.sh`
- Script: step 7 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step6_megares_bwa`
- Output directory for count table: `$run_dir/step7_norm_count_tab/resistomeanalyzer_output`
- Output directory for normalized count table: `$run_dir/step7_norm_count_tab/normalized_tab`

## STEP 8. Assemble reads into contigs with megaHIT
- Initialization: download MEGAHIT-1.2.9 `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_megaHIT.sh`
- Script: step 8 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step2_trim`
- Output directory: `$run_dir/step8_megahit_in_trimmomatic`

Make sure to use only paired-end reads for assembly. Merged reads may have low quality near the center of the reads, which will impact MEGAHIT performance. 

## STEP 9. Align short reads containing ARGs to contigs
- Script: step 9 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input directory: `$run_dir/step6_megares_bwa`
- Output directory for mapped ARG fastqs (mapped/aligned to MEGARes db): `$run_dir/step9_contig_bwa_nomerg/mapped_fastq`
- Output directory for ARG-contig alignment sam files: `$run_dir/step9_contig_bwa_nomerg`
- Output directory for contig fasta files: `$run_dir/step9_contig_bwa_nomerg`


## STEP 10. ID the taxonomy of contigs using taxator-tk 
- Initialization: download CAT v5.0.3 `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_CAT.sh`
- Script: step 10 in `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/ARG_pipeline_v0.3.sh`
- Input files: `$run_dir/step9_contig_bwa_nomerg/*.fa`
- Output directory: `$run_dir/step10_CAT`

## Non-AMR pipeline: Community taxa identification with kraken2 and bracken
- Initialization for kraken2: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_kraken2`
- Initialization for bracken: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_bracken`
- Script: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/kraken2.sh`
- Input files:`$run_dir/step3_fastuniq`
- Output files: `$run_dir/kraken2_ver2`


## Non-AMR pipeline: Align merged reads to KEGG database to identify the functional metagenome
- Initialization: Danielle purchased and downloaded KEGG. See `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_KEGG` for instructions on database organization
- Script: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/kegg.sh`
- Input directory: `$run_dir/step4_flash`
- Output directory: `$run_dir/kegg_prokaryotes_pep`


This step performs (1) alignment to KEGG prokaryotes genes, (2) count the alignment, (3) normalize count tables with MicrobeCensus. 

## Non-AMR pipeline: Align merged reads to CAZy database to identify carbohydrate associated enzymes
- Initialization: download and organize CAZy database `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_CAZy_db.sh`
- Script: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/CAZy_diamond.sh`
- Input directory: `$run_dir/step4_flash`
- Output directory: `$run_dir/CAZy_diamond`


This step performs (1) alignment to CAZy database, (2) count the alignment, (3) normalize count tables with MicrobeCensus. 

## Non-AMR pipeline: Align merged reads to custom beta-galactosidase database
- Initialization: download and organize b-gal database:  `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/init/install_b-galactosidase_db.sh`
- Script: `/share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/b_galac_diamond.sh`
- Input directory: `$run_dir/step4_flash`
- Output directory: `$run_dir/b_galac_diamond`

This step performs (1) alignment to b-gal database, (2) count the alignment, (3) normalize count tables with MicrobeCensus. 
