# Didn't write down the actual installation notes (lost during git merging?)

# test with the precompiled database
cd /share/lemaylab-backedup/databases/

# transfer file from laptop to spitfire
rsync -vrazh ~/Downloads/nonredundant-microbial_20121122.tar.xz xzyao@spitfire.genomecenter.ucdavis.edu:/share/lemaylab-backedup/databases/nonredundant-microbial_20121122.tar.xz

tar xvf nonredundant-microbial_20121122.tar.xz

mkdir build/
mv nonredundant-microbial_20121122.tar.xz build/

# Format database
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxknife -f 2 --mode traverse -r species genus family order class phylum superkingdom < /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/mapping.tax > /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/newmapping.tax
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/makeblastdb -in /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/refdata.fna -dbtype nucl -logfile /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/log_makedb.txt -out blastdb_refdata 


# Test taxator-tk with the pre-compiled database and a small set of contig 
export TAXATORTK_TAXONOMY_NCBI=/share/lemaylab-backedup/databases/nonredundant-microbial_20121122/ncbi-taxonomy


/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/blastn -task blastn -db /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/blastdb_refdata -outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_taxator_nomerg/split_fa/8052_split_at | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a megan-lca -t 0.3 -e 0.01 -g /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/newmapping.tax | sort -k1,1 > /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/test_predictions.gff3
# An unrecoverable error occurred: std::exception
# Here is some debugging information to locate the problem:
# /home/johdro/projects/taxator-tk_default.git/src/fileparser.hh(52): Throw in function FileParser<FactoryType>::RecordType* FileParser<FactoryType>::next() [with FactoryType = AlignmentRecordFactory<AlignmentRecordTaxonomy>; FileParser<FactoryType>::RecordType = AlignmentRecordTaxonomy]
# Dynamic exception type: boost::exception_detail::clone_impl<Exception>
# std::exception::what: std::exception
# [exception_tag_line*] = 1
# [exception_tag_general*] = bad score

# remove spaces in the fasta header
sed 's/ /_/g' /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_taxator_nomerg/split_fa/8052_split_at > /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/8052_split_at_nospace
# make fai index 

# blastn alone
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/blastn -task blastn -db /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/blastdb_refdata -outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query 8052_split_at_nospace > blastn_output.txt

cat blastn_output.txt | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a megan-lca -t 0.3 -e 0.01 -g /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/newmapping.tax > test_predictions.gff3
# An unrecoverable error occurred: std::exception
#Here is some debugging information to locate the problem:
#/home/johdro/projects/taxator-tk_default.git/src/fileparser.hh(52): Throw in function FileParser<#FactoryType>::RecordType* FileParser<FactoryType>::next() [with FactoryType = AlignmentRecordFactory<#AlignmentRecordTaxonomy>; FileParser<FactoryType>::RecordType = AlignmentRecordTaxonomy]
#Dynamic exception type: boost::exception_detail::clone_impl<Exception>
#std::exception::what: std::exception
#[exception_tag_line*] = 1
#[exception_tag_general*] = bad score



# Make blast index instead of full database
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/makeblastdb -in /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/refdata.fna -dbtype nucl -input_type fasta -parse_seqids -logfile log_makedb2.log -out "blastdb_refdata2" 2>/dev/null && echo 'Success.' || echo 'Failed.' 1>&2
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/blastn -task blastn -db /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/blastdb_refdata2 -outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query 8052_split_at_nospace > blastn_output2.txt
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/blastn -task blastn -db /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/blastdb_refdata2 -outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query 8052_split_at_nospace | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a megan-lca -g /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/newmapping.tax > test_predictions.gff3
cat blastn_output2.txt | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -g newmapping.tax -q 8052_split_at_nospace -f refdata.fna -i refdata.fna.fai > my.predictions.unsorted.gff3
# Even after removing the megan-lca scores, still give and bad score error
# Try rpa prediction # this method load all refdata.fna, could be very slow
cd  /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/
cat blastn_output2.txt | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a rpa -q 8052_split_at_nospace -f refdata.fna -g newmapping.tax -p 10 > my.predictions.unsorted.gff3
#Loading '8052_split_at_nospace' (total=38)
#0%   10   20   30   40   50   60   70   80   90   100%
#|----|----|----|----|----|----|----|----|----|----|
#***************************************************
#*
#Loading 'refdata.fna' (total=317656)
#
#0%   10   20   30   40   50   60   70   80   90   100%
#|----|----|----|----|----|----|----|----|----|----|
#***************************************************
#
#taxator: /usr/include/boost/thread/pthread/condition_variable.hpp:125: boost::condition_variable_any::~condition_variable_any(): Assertion `!pthread_mutex_destroy(&internal_mutex)' failed.
#Aborted




################
# Danielle suggested that it may be a file parsing error because the fasta header contains weird characters 
# Check if the fasta header is unique if keeping only the first part of the header 
# From ">k141_21819 flag=0 multi=22.3372 len=4936" to ">k141_21819"
awk '/^>/ {$0=$1} 1' /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step9_contig_bwa_nomerg/8052_contig_ARGread_aln_mappedonly.fa > /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/8052_contig_ARGread_aln_mappedonly_partial.fa

cd /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/
grep ">" 8052_contig_ARGread_aln_mappedonly_partial.fa | sort | uniq -d > 8052_partial_dup_header.txt # no duplicate

# run taxator-tk pipeline on fasta file with parital header 
# subset to contain only a couple lines 
head 8052_contig_ARGread_aln_mappedonly_partial.fa -n 300  > 8052_partial_head.fa

/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/blastn -task blastn -db blastdb_refdata -outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query 8052_partial_head.fa > blastn_output.txt

cat blastn_output.txt | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a megan-lca -t 0.3 -e 0.01 -g /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/newmapping.tax > test_predictions.gff3

# Yay? a new/different error message?
#An unrecoverable error occurred: std::exception

#Here is some debugging information to locate the problem:
#/home/johdro/projects/taxator-tk_default.git/src/fileparser.hh(52): Throw in function FileParser<FactoryType>::RecordType* FileParser<FactoryType>::next() [with FactoryType = AlignmentRecordFactory<AlignmentRecordTaxonomy>; FileParser<FactoryType>::RecordType = AlignmentRecordTaxonomy]
#Dynamic exception type: boost::exception_detail::clone_impl<Exception>
#std::exception::what: std::exception
#[exception_tag_file*] = /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/newmapping.tax
#[exception_tag_line*] = 14
#[exception_tag_seqid*] = NZ_JH636035.1
#[exception_tag_general*] = bad taxon mapping for alignment reference sequence

# try the taxator portion with the mapping file that I downloaded from the pre-compiled version
cat blastn_output.txt | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a megan-lca -t 0.3 -e 0.01 -g /share/lemaylab-backedup/databases/nonredundant-microbial_20121122/mapping.tax > test_predictions.gff3
# An unrecoverable error occurred: std::exception
#Here is some debugging information to locate the problem:
#/home/johdro/projects/taxator-tk_default.git/src/fileparser.hh(52): Throw in function FileParser<FactoryType>::RecordType* FileParser<FactoryType>::next() [with FactoryType = AlignmentRecordFactory<AlignmentRecordTaxonomy>; FileParser<FactoryType>::RecordType = AlignmentRecordTaxonomy]
#Dynamic exception type: boost::exception_detail::clone_impl<Exception>
#std::exception::what: std::exception
#[exception_tag_line*] = 54
#[exception_tag_general*] = bad score

cat blastn_output.txt | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a rpa -q 8052_partial_head.fa -f refdata.fna -g newmapping.tax -p 10 > my.predictions.unsorted.gff3

#Loading '8052_partial_head.fa' (total=8)

#0%   10   20   30   40   50   60   70   80   90   100%
#|----|----|----|----|----|----|----|----|----|----|
#***************************************************
#*******
#Loading 'refdata.fna' (total=317656)
#
#0%   10   20   30   40   50   60   70   80   90   100%
#|----|----|----|----|----|----|----|----|----|----|
#***************************************************

#taxator: /usr/include/boost/thread/pthread/condition_variable.hpp:125: boost::condition_variable_any::~condition_variable_any(): Assertion `!pthread_mutex_destroy(&internal_mutex)' failed.
#Aborted

