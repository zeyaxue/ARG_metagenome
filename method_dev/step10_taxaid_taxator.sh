#!/bin/bash

########################################################################################################################
#
# STEP 10. ID the taxonomy of contigs using taxator-tk 

echo "NOW STARTING TAXONOMY ID AT: "; date

megahit_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step8_megahit
mkdir /share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_bbsketch
taxaid_outdir=/share/lemaylab-backedup/Zeya/proceesed_data/NovaSeq043/step10_bbsketch

# Make sure bash knows where to look for softwares 
taxator=


export TAXATORTK_TAXONOMY_NCBI="/share/lemaylab-backedup/milklab/database/refseq"


for file in $aln_outdir/*_contig_aln.fasta
do
	STEM=$(basename "$file" _contig_aln.fasta)

	echo "Processing sample $file now...... "

	blastn -task blastn -db DATABASE --outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query $file | taxator -a megan-lca -t 0.3 -e 0.01 -g acc_taxid.tax > $.txt
done	

echo "STEP 10 DONE AT: "; date


####Below this worked
# -h for help 
# -a: taxa assignment algorithmn, -g:taxid mapping file, -p: threads
export TAXATORTK_TAXONOMY_NCBI="/share/lemaylab-backedup/milklab/database/refseq"

/software/blast/2.9+/lssc0-linux/bin/blastn -db /share/lemaylab-backedup/milklab/database/refseq/blastdb_test100 -outfmt '6 qseqid qstart qend qlen sseqid sstart send bitscore evalue nident length' -query /share/lemaylab-backedup/milklab/database/refseq/query_test.fna ######
 | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a megan-lca -t 0.3 -e 0.01 -g /share/lemaylab-backedup/milklab/database/refseq/nucl_wgs_taxidmap4.txt > taxator_predictions_test.gff3
#An unrecoverable error occurred: std::exception
#
#Here is some debugging information to locate the problem:
#/home/johdro/projects/taxator-tk_default.git/src/fileparser.hh(52): Throw in function FileParser<FactoryType>::RecordType* FileParser<FactoryType>::next() [with #FactoryType = AlignmentRecordFactory<AlignmentRecordTaxonomy>; FileParser<FactoryType>::RecordType = AlignmentRecordTaxonomy]
#Dynamic exception type: boost::exception_detail::clone_impl<Exception>
#std::exception::what: std::exception
#[exception_tag_file*] = nucl_wgs_taxidmap4.txt
#[exception_tag_line*] = 1
#[exception_tag_seqid*] = ref|NZ_NFNG01000029.1|
#[exception_tag_general*] = bad taxon mapping for alignment reference sequence


# for LAST
/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/lastal -f 1 /share/lemaylab-backedup/milklab/database/refseq/refseq_all_bacteria_test100_last /share/lemaylab-backedup/milklab/database/refseq/query_test.fna | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/lastmaf2alignments | sort -k1,1 | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a n-best-lca -n 1 -g /share/lemaylab-backedup/milklab/database/refseq/nucl_wgs_taxidmap4.txt > my.predictions.gff3
# ##gff-version 3
#jejeju	taxator-tk	sequence_feature	1	325	0	.	.	seqlen=325;tax=197:325;rtax=197



/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/lastal -f 1 /share/lemaylab-backedup/milklab/database/refseq/refseq_all_bacteria_test100_last /share/lemaylab-backedup/milklab/database/refseq/query_test.fna | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/lastmaf2alignments | sort -k1,1 | tee <(gzip > my.alignments.gz) | /share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/taxator -a rpa -g /share/lemaylab-backedup/milklab/database/refseq/nucl_wgs_taxidmap4.txt -q query.fna -v query.fna.fai -f ref.fna -i ref.fna.fai -p 10 | sort -k1,1 > my.predictions.gff3

#An unrecoverable error occurred: could not find file
#
#Here is some debugging information to locate the problem:
#/home/johdro/projects/taxator-tk_default.git/src/sequencestorage.hh(58): Throw in function RandomInmemorySeqStoreRO<StorageStringType, #WorkingStringType, Format>::RandomInmemorySeqStoreRO(const string&) [with StorageStringType = seqan::String<seqan::SimpleType<unsigned #char, seqan::Dna5_>, seqan::Alloc<> >; WorkingStringType = seqan::String<seqan::SimpleType<unsigned char, seqan::Dna5_>, seqan::Alloc<> >;# Format = seqan::Tag<seqan::TagFasta_>; std::string = std::basic_string<char>]
#Dynamic exception type: boost::exception_detail::clone_impl<FileNotFound>
#std::exception::what: could not find file
#[exception_tag_file*] = 


/share/lemaylab-backedup/milklab/programs/taxator-tk_1.3.3e-64bit/bin/binner < my.predictions.gff3 -i genus:0.6 > my.tax
taxknife -f 2 --mode annotate -s name < my.tax

