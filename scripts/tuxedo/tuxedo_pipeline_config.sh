# Configuration file for the pipeline
## Edit this script with the sample and tools locations. 
## Then place this file in the same folder with the main script file.  

numcpus=42

## File paths for input samples and to save output
basedir=/home/usr/rnaseq/GSE190381
sampledirPath="$basedir/rawdata/"
outdir="$basedir/output/"

samples=("SRR17156692","SRR17156693","SRR17156694","SRR17156701","SRR17156702","SRR17156703")
names=("a333fs_rep1","a333fs_rep2","a333fs_rep3","negControl_rep1","negControl_rep2","negControl_rep3")

indexfile=/full/path/to/hisat_index/grch38/genome
gtffile=/full/path/to/gencode.v41.primary_assembly.annotation.gtf
phenodata=/full/path/to/file/phenodata.csv

## Program paths - If the programs are not in Path location, explicitly mention the complete folder path having the tool
Trimgalore=$(which trim_galore)
Hisat2=$(which hisat2)
Stringtie=$(which stringtie)
Samtools=$(which samtools)

rna_strandedness_hisat2=RF
### The default rna_strandedness considered for stringtie steps is --rf. If anyother, change accordingly in the main script for all stringtie steps



