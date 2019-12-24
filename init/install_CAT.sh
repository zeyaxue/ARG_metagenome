#!/bin/bash

cd /share/lemaylab-backedup/milklab/programs
wget https://github.com/dutilh/CAT/archive/v5.0.3.tar.gz
mv v5.0.3.tar.gz CAT_v5.0.3.tar.gz
tar xvzf CAT_v5.0.3.tar.gz

# Dowload the database files
cd /share/lemaylab-backedup/milklab/database/
wget https://tbb.bio.uu.nl/bastiaan/CAT_prepare/CAT_prepare_20190719.tar.gz
tar -xvzf CAT_prepare_20190719.tar.gz
#output
#CAT_prepare_20190719/
#CAT_prepare_20190719/2019-07-19.CAT_prepare.fresh.log
#CAT_prepare_20190719/2019-07-19_CAT_database/
#CAT_prepare_20190719/2019-07-19_CAT_database/2019-07-19.nr.dmnd
#CAT_prepare_20190719/2019-07-19_CAT_database/2019-07-19.nr.fastaid2LCAtaxid
#CAT_prepare_20190719/2019-07-19_CAT_database/2019-07-19.nr.taxids_with_multiple_offspring
#CAT_prepare_20190719/2019-07-19_CAT_database/2019-07-19.nr.gz
#CAT_prepare_20190719/2019-07-19_taxonomy/
#CAT_prepare_20190719/2019-07-19_taxonomy/division.dmp
#CAT_prepare_20190719/2019-07-19_taxonomy/2019-07-19.taxdump.tar.gz
#CAT_prepare_20190719/2019-07-19_taxonomy/gc.prt
#CAT_prepare_20190719/2019-07-19_taxonomy/2019-07-19.prot.accession2taxid.gz
#CAT_prepare_20190719/2019-07-19_taxonomy/gencode.dmp
#CAT_prepare_20190719/2019-07-19_taxonomy/nodes.dmp
#CAT_prepare_20190719/2019-07-19_taxonomy/merged.dmp
#CAT_prepare_20190719/2019-07-19_taxonomy/names.dmp
#CAT_prepare_20190719/2019-07-19_taxonomy/citations.dmp
#CAT_prepare_20190719/2019-07-19_taxonomy/readme.txt
#CAT_prepare_20190719/2019-07-19_taxonomy/delnodes.dmp

# Download the md5 file of the database
cd CAT_prepare_20190719
wget https://tbb.bio.uu.nl/bastiaan/CAT_prepare/CAT_prepare_20190719.tar.gz.md5
# perform checksum myself
md5sum /share/lemaylab-backedup/milklab/database/CAT_prepare_20190719.tar.gz > /share/lemaylab-backedup/milklab/database/CAT_prepare_20190719/checksum_check.txt  
# compare the check sum
diff CAT_prepare_20190719/checksum_check.txt CAT_prepare_20190719/CAT_prepare_20190719.tar.gz.md5 
#output: the same check sum
#1c1
#< 7c3d6a405286ac572920c37c9da70749  /share/lemaylab-backedup/milklab/database/CAT_prepare_20190719.tar.gz
#---
#> 7c3d6a405286ac572920c37c9da70749  CAT_prepare_20190719.tar.gz

# Check the version of DIAMOND 
cd /share/lemaylab-backedup/milklab/database/
grep version CAT_prepare_20190719/2019-07-19.CAT_prepare.fresh.log 
#output
#[2019-07-19 19:42:52.803479] DIAMOND found: diamond version 0.9.21.
/share/lemaylab-backedup/milklab/programs/diamond help
#output 
#diamond v0.8.38.100 | by Benjamin Buchfink <buchfink@gmail.com>
#download the same version of diamond
cd ../programs/
wget https://github.com/bbuchfink/diamond/releases/download/v0.9.21/diamond-linux64.tar.gz
tar -xvzf diamond-linux64.tar.gz # oops, it overwrote the old version
# check version again 
/share/lemaylab-backedup/milklab/programs/diamond help
#diamond v0.9.21.122 | by Benjamin Buchfink <buchfink@gmail.com>


# Install prodigal
wget https://github.com/hyattpd/Prodigal/archive/v2.6.3.tar.gz
tar -xvzf v2.6.3.tar.gz
ls Prodigal-2.6.3
#bitmap.c  CHANGES  dprog.h  gene.h   main.c    metagenomic.c  node.c  README.md   sequence.h  training.h
#bitmap.h  dprog.c  gene.c   LICENSE  Makefile  metagenomic.h  node.h  sequence.c  training.c  VERSION
cd Prodigal-2.6.3




mkdir CAT-5.0.3_original/
rsync -av CAT-5.0.3/ CAT-5.0.3_original/
cd /share/lemaylab-backedup/milklab/programs/CAT-5.0.3/CAT_pack
# change shebang line in contigs.py & add_names.py & summarise.py
# #!/software/python/3.6.2/x86_64-linux-ubuntu14.04/bin/python3.6
