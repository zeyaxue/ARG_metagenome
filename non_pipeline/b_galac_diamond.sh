run_dir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043

# DIAMOND
diamond_location=/share/lemaylab-backedup/milklab/programs/diamond
db=/share/lemaylab-backedup/databases/b-galactosidase/db_with_B-galac.dmnd

####################################################################
#
# Align to b-gal database with diamond
# for diamond usage, read manual: https://github.com/bbuchfink/diamond

output_dir_flash=$run_dir/step4_flash
mkdir $run_dir/b_galac_diamond
output_dir_diamond=$run_dir/b_galac_diamond

for file in $output_dir_flash/*.extendedFrags.fastq
do
	STEM=$(basename "$file" .extendedFrags.fastq)

    # eval chosen based on recommendations for 200-250bp reads
    $diamond_location blastx --db $db -q $file -a $output_dir_diamond/${STEM}.daa -t ./ -k 1 --sensitive --evalue 1e-25
    $diamond_location view --daa $output_dir_diamond/${STEM}.daa -o $output_dir_diamond/${STEM}.txt -f tab  
done


for file in $output_dir_diamond/*.daa
do      
    STEM=$(basename "$file" .daa)

    python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/CAZy_db_analysis_counter.py --in $output_dir_diamond/${STEM}.txt --out $output_dir_diamond/${STEM}_org_by_gene.csv

    # organize and merge raw counts table
    #python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/merge_organized_diamond_tab.py \
    #--in $output_dir_diamond/${STEM}_org.txt \
    #--out $output_dir_diamond/${STEM}_org_samid.txt \
    #--mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument 

    # organize and merge raw counts table
    #python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/merge_organized_diamond_tab.py \
    #--mergeout $output_dir_diamond/merged_diamond_tab.csv \
    #--mergein $output_dir_diamond/*_org_samid.txt

    python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/make_CAZy_normtab.py \
    --mc $run_dir/step5_MicrobeCensus_merged/${STEM}_mc.txt \
    --genelen /share/lemaylab-backedup/databases/b-galactosidase/db_with_B-galac_len_clean.txt \
    --count $output_dir_diamond/${STEM}_org_by_gene.csv \
    --out $output_dir_diamond/${STEM}_org_norm.csv \
    --mergein $file # This argument does not do anything here, but python2 requires *args to be not empty so I supply a dummy argument (if using python3, can omit this input)
done

python /share/lemaylab-backedup/Zeya/scripts/ARG_metagenome/non_pipeline/make_CAZy_normtab.py --mergeout $output_dir_diamond/b-gal_merged_gene_norm_tab.csv --mergein $output_dir_diamond/*_org_norm.csv


echo "B-galactosidase alignment DONE AT: "; date
