#!/usr/bin/python

'''This script requies 3 input files and an output file path:
	(1) MicrobeCensus output txt file.
	(2) Organized table of MEGARes database gene length.
	(3) Resistome Analyzer gene level output. Other levels are also included in this file and can be collapsed in final output files if desired.'''

'''Usage: python make_RPKG_normtab.py --mc path/to/file.txt --genelen path/to/megares_modified_database_v2_GeneLen_org.tsv --count /path/to/xxgene.tsv --out path/to/normalized_tab.tsv"'''

import pandas as pd
import csv
import numpy
import os
import re

# To ensure that the script can be run by itself and functions imported as modules
if __name__ == "__main__":
	# parse input argument 
	import argparse
	parser = argparse.ArgumentParser(description='Process input and output arguments.')
	parser.add_argument('--mc', type=str, help='File path to MicrobeCensus output txt file.')
	parser.add_argument('--genelen', type=str, help='File path to organized gene length table from MEGARes databse.')
	parser.add_argument('--count', type=str, help='File path to count table generated by ResistomeAnalyzer.')
	parser.add_argument('--out', type=str, help='Location to write the normalized count table')
	args = vars(parser.parse_args())


# Define function to calculate normalized table
def make_RPKG_normtab(mcfp, lenfp, countfp, outfp):
	# 1 # read in MicrobeCensus genome equivalents output
	mctab = pd.read_csv(mcfp, sep="\t") # read in file
	ge = float(mctab.at['genome_equivalents:', 'Parameters']) # get the value for genome equivalents


	# 2 # read in organized gene length table ("megares_modified_database_v2_GeneLen_org.tsv")
	lentab = pd.read_csv(lenfp, sep='\t', header=0).set_index('MEGID')


	# 3 # read in count table generated by Resistome Analyzer at gene level (also cotains, group, mechanism and class info)
	countab = pd.read_csv(countfp,
						  names=['Sample','MEGID','Class','Mechanism','Group','Gene','Hits','GeneFrac','DUM','MY'], # add column names
						  sep="\t|[|]|RequiresSNPConfirmation", engine='python',
						  header=None).set_index('MEGID')
	countab = countab.drop('Gene', axis=0) # Remove the first row which contains pre-parsing header
	
	# Remove all the NaN genenrated in the middle of the df due to parsing "RequiresSNPConfirmation"
	for i in countab.index:
		if numpy.isnan(countab.at[i,'Hits']):
			countab.at[i,'Hits'] = countab.at[i,'DUM']
			countab.at[i,'GeneFrac'] = countab.at[i,'MY']
	countab = countab.drop(columns=['DUM','MY'])
	
	# assumes sample name is the character string after the last / and before .tsv
	# The sample name is 5007 from the path /file/to/your/path/5007_gene.tsv
	fn = os.path.basename(countfp) # get the xx_gene.tsv file name
	samid = re.search('(.+?)_gene.tsv', fn).group(1)
	# remove the "align" suffix after sample name
	countab_fin = countab.replace(countab.at[i, 'Sample'], samid) # I hitched the last i value from the previous loop


	# 4 # Calculate to get the final normalized table 
	normtab=countab_fin.copy() # initialize with an empty dataframe
	RPKG = [] # initialize with an empty 
	
	for i in normtab.index:
	    # equation: Hits/((len in kb)*GE)
	    len = lentab.at[i,'Len']/1000
	    norm_val = normtab.at[i,'Hits']/(len*ge) 
	    RPKG.append(norm_val)
	    
	normtab['RPKG'] = RPKG # add a new column with RPKG
	
	# remove sample column and replace the RPKG column header with sample name
	normtab_fin = normtab.rename(columns={'RPKG':normtab.at[i,'Sample']}) 
	print(normtab)
	
	# 5 # Write out the final table
	normtab_fin.to_csv(outfp, mode='a', sep='\t')


# Excute 
make_RPKG_normtab(mcfp=args['mc'], 
				  lenfp=args['genelen'], 
				  countfp=args['count'], 
				  outfp=args['out'])         





