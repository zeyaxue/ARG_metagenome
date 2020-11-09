#!/usr/bin/env python
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
from collections import Counter
import pandas as pd

# create flag arguments:
parser = argparse.ArgumentParser()

parser.add_argument("-I", "--infile", dest = "input", help = "input file", nargs='+') 		  # second flag argument
parser.add_argument("-O", "--output", dest = "output", help = "output file") 	  # third flag argument

args = parser.parse_args()

in_file = args.input 	# set second flag argument to a variable
out_file = args.output 	# set third flag argument to a variable

print("Input file: %s, Output file: %s") % (args.input, args.output)

genes = [] 									# create a blank list 
for file in in_file:
	with open(file, 'rU') as f:
		for line in f:
			x = re.split('[: \t]', line)		# split each row by special characters
			genes.append(x[7])					# append id names to blank list
counts = Counter(genes)

# write out the dictionary as a csv file
# help from https://stackoverflow.com/questions/18837262/convert-python-dict-into-a-dataframe
df = pd.DataFrame(counts.items(), columns=['Gene','Counts'], index=None) 
df.to_csv(out_file, sep=',', index=False)	
