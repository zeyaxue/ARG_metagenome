#!/usr/bin/env Python
# CAZY_db_analysis_counter.py by Michelle Treiber
# Created on 8/15/17
# Modified by Zhengyao (Zeya) Xue on 01/16/2020
#
# Python script created to sort through DIAMOND annotation results
# and create one master output table that show CAZy family totals
# for every sample.
#
##############################################################################
#
# Usage:
#
# -ref		reference		Text file containing a list of all CAZy families
# 								(output from get_all_families_mlt.pl)
#
# -I		infile			DIAMOND annotation results file(s)
#
# -O 		output			Name of output file formatted to have the sample 
# 								name as the column name and the CAZy family 
#								name as the row
#
# Example reference list:
#  AA0
#  AA1
#  AA10
#
# Example input file:
#  J00113:48:H3TLJBBXX:1:1101:5700:1279    EFC70397.2|GH2  70.7    41      12      0       124     2       139     179     1.3e-12 73.2
#  J00113:48:H3TLJBBXX:1:1101:15463:1279   AGB28837.1|GT5  98.1    52      1       0       162     7       50      101     3.0e-22 105.5
#  J00113:48:H3TLJBBXX:1:1101:29691:1279   BAS15972.1|GH130        45.3    53      29      0       159     1       215     267     3.3e-05 48.9
#
# Example results file:
#  AA0 		3			
#  AA1 		15			
#  AA10 	8			
#
# Example usage: python CAZy_db_analysis_counter.py -ref CAZy_families.txt -I control_1.merged.annotCAZy.txt -O control_1.annotCAZy_table.csv
#
##############################################################################
from sys import argv
import argparse
import re

# create flag arguments:
parser = argparse.ArgumentParser()

parser.add_argument("-ref", "--reference", dest = "ref", help = "reference list") # first flag argument
parser.add_argument("-I", "--infile", dest = "input", help = "input file", nargs='+') 		  # second flag argument
parser.add_argument("-O", "--output", dest = "output", help = "output file") 	  # third flag argument

args = parser.parse_args()

# check if there are enough arguments passed
if len(vars(args)) != 3:
	print 'ERROR: Too few arguments. Must include reference list, input file, and output file\nExample usage: python CAZy_db_analysis_counter.py -ref CAZy_families.txt -I *.merged.annotCAZy.txt -O annotCAZy_table.txt'

print("Reference list: %s, Input file: %s, Output file: %s") % (args.ref, args.input, args.output)

ref_list = args.ref 	# set first flag argument to a variable
in_file = args.input 	# set second flag argument to a variable
out_file = args.output 	# set third flag argument to a variable

# open output file to write to
out = open(out_file, 'a')

fam = [] 									# create a blank list 
for file in in_file:
	with open(file, 'rU') as f:
		for line in f:
			x = re.split('[: \t |]', line)		# split each row by special characters
			fam.append(x[8])					# append family names to blank list
#print fam

ref = []									# create a blank list 
with open(ref_list, 'rU') as f:
	for line in f:
		x = re.split('\n', line)			# split each row by new line character
		ref.append(x[0]) 					# append family names to blank list
#print ref

counts = {}						# create blank dictionary
for i in ref:
	#print i
	counts[i] = fam.count(i)	# count how many times family name from input file appears in reference file
#print counts

for k, v in sorted(counts.iteritems()):
	print >> out, '%s, %s' % (k, v) # seperate keys and values with a comma

#print fam.counter('GH2')
	#print contents
