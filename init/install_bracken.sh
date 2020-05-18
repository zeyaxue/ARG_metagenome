#https://github.com/jenniferlu717/Bracken
cd /share/lemaylab-backedup/milklab/programs/
wget https://github.com/jenniferlu717/Bracken/archive/v2.6.0.tar.gz

tar -xvf v2.6.0.tar.gz 
rm v2.6.0.tar.gz

# Installation in the "easy" mode
cd Bracken-2.6.0/
sh install_bracken.sh 

# Generate the Bracken database file
./bracken-build -d /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi -t 30 -k 35 -l 151 -x /share/lemaylab-backedup/milklab/programs/kraken2-2.0.9b/
#09506.1)	44702 sequences converted
#	Time Elaped: 84 minutes, 8 seconds, 0.00000 microseconds
#	=============================
#PROGRAM START TIME: 05-16-2020 20:45:54
#...9338 total genomes read from kraken output file
#...creating kmer counts file -- lists the number of kmers of each classification per genome
#...creating kmer distribution file -- lists genomes and kmer counts contributing to each genome
#PROGRAM END TIME: 05-16-2020 20:45:55
#          Finished creating database151mers.kraken and database151mers.kmer_distrib [in DB folder]
#          *NOTE: to create read distribution files for multiple read lengths, 
#                 rerun this script specifying the same database but a different read length
#
#Bracken build complete.


# Compute classifications for each perfect read from one of the input sequences
 ./src/kmer2read_distr --seqid2taxid /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi/seqid2taxid.map --taxonomy /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi/taxonomy --kraken /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi/database.kraken --output /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi/database151mers.kraken -k 35 -l 151 -t 30
#44702 sequences converted
#	Time Elaped: 83 minutes, 45 seconds, 0.00000 microseconds

# Generate the kmer distribution file
python ./src/generate_kmer_distribution.py -i /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi/database151mers.kraken -o /share/lemaylab-backedup/databases/kraken2-bact-arch-fungi/database151mers.kmer_distrib















