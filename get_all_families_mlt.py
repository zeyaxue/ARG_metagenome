#!/usr/bin/python
# get_all_families_mlt.py
# Created by Michelle Treiber August 25, 2017
#
# Python script ceated to sort through CAZy database header and save 
# only the family name in a text output file
#
##############################################################################
#
# Usage:
#
# -db 		CAZy database		Fasta formatted CAZy database
#
# -O 		output				Output file formatted as a text file
#									that lists all family names
#
# Example database format:
# >AAL35364.1|AA0
# MEYYYNYNSINKMVSIIFILVLAIDLTMVLGQGTRVGFYSSTCPRAESIVQSTVRSHFQSDPTVAPGLLTMHFHDCFVQGCDASILISGSGTERTAPPNSLLRGYEVIDDAKQQIEAICPGVVSCADILALAARDSVLVTKGL....
# >AAF96709.1|AA10|1.-.-.-
# MKKQPKMTAIALILSGISGLAYGHGYVSAVENGVAEGRVTLCKFAANGTGEKNTHCGAIQYEPQSVEGPDGFPVTGPRDGKIASAESALAAALDEQTADRWVKRPIQAGPQTFEWTFTANHVTKDWKYYITKPNWNPNQPLSR....
#
# Example output file:
# AA0
# AA1
# AA10
#
# Example usage:
# python get_all_families.py -db CAZy_db.fa -O CAZy_families.txt
##############################################################################
#
from sys import argv
import argparse
import re

# create flag arguments:
parser = argparse.ArgumentParser()

parser.add_argument("-db", "--database", dest = "db", help = "CAZy database") # first flag argument
parser.add_argument("-O", "--output", dest = "output", help = "output file")  # second flag argument

args = parser.parse_args()
store = vars(args)
count = sum([ 1 for a in store.values( ) if a]) # total number of arguments passed through the command line

# check if there are enough arguments passed
if count != 2:
	print 'ERROR: Too few arguments.\nMust include reference list, input file, and output file\nExample usage: python get_all_families.py -db CAZy_db.fa -O CAZy_families.txt'
	sys.exit(0)

print("Database: %s, Output file: %s") % (args.db, args.output)

database = args.db 	# set first flag argument to a variable
out_file = args.output 	# set third flag argument to a variable

# open output file to write to
out = open(out_file, 'w')

# Store lists outside of loop:
family = []
# Loop through database and append every family name to list:
with open(database, 'rU') as f:
	for line in f:
		if line.startswith('>'):
			x = re.split('[> | \n]', line) # split each header all '>' '|' and '\n' characters
			family.append(x[2])			   # save all values to list

unique_fam = set(family)		# store unique family names
for x in sorted(unique_fam):	# alphabetize unique family names
	print >> out, x				# print values to output

