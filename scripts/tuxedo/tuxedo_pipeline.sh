#!/bin/bash

## Check for and then run the configuration script having the paths for the tools and input data and output folder.
if [[ ! -f ./tuxedo_pipeline_config.sh ]]; then
 echo "Error: Configuration file (tuxedo_pipeline_config.sh) missing!"
 exit 1
fi
source ./tuxedo_pipeline_config.sh

## Create the specified output directory if not present,and then the required subdirectories
if [[ $outdir != "." ]]; then
  mkdir -p $outdir
  cd $outdir
fi

mkdir "${outdir}/trimmed"
mkdir "${outdir}/hisat"
mkdir "${outdir}/stringtie"
mkdir "${outdir}/ballgown"

## Check if the tools are correctly specified with the paths of where they are installed.
### i.e. check if the specified file for the tool is executable
if [[ ! -x $Trimgalore ]]; then
 echo "trim_galore not found. Please install Trimgalore or correctly specify the path of the executable in Config file."
 exit 1
fi

if [[ ! -x $Hisat2 ]]; then
 echo "hisat2 not found. Please install Hisat2 or correctly specify the path of the executable in Config file."
 exit 1
fi

if [[ ! -x $Samtools ]]; then
 echo "samtools not found. Please install samtools or correctly specify the path of the executable in Config file."
 exit 1
fi

if [[ ! -x $Stringtie ]]; then
 echo "stringtie not found. Please install Stringtie or correctly specify the path of the executable in Config file."
 exit 1
fi

if [[! -f de_ballgown.R]]; then
 echo "de_ballgown.R not found. Save it in the folder having this script"
 exit 1	
fi

## Tuxedo pipeline (Hisat2, samtools, Stringtie first run) looped over each sample
for ((i=0; i<${#samples[@]}; i++));
do
 echo "Running Trimgalore on the sample ""${names[$i]}"
 ${Trimgalore} --paired --illumina -o ${outdir}/trimmed ${sampledirPath}/${samples[$i]}_1.fastq.gz ${sampledirPath}/${samples[$i]}_2.fastq.gz 

 echo "Running Hisat2 on the sample ""${names[$i]}"
 $Hisat2 -p ${numcpus} --add-chrname --dta --new-summary --summary-file ${outdir}/hisat/${samples[$i]}_hisat_summary.txt --time  --rna-strandness ${rna_strandedness_hisat2} -x ${indexfile} -1 ${sampledirPath}/${samples[$i]}_val_1.fq.gz -2 ${sampledirPath}/${samples[$i]}_val_2.fq.gz -S ${outdir}/hisat/${samples[$i]}_htOut.sam

 echo "Running Samtools sort on  ""${names[$i]}"
 $Samtools view -@ ${numcpus} -S -b ${outdir}/hisat/${samples[$i]}_htOut.sam  > ${outdir}/hisat/${samples[$i]}_htOut.bam
 $Samtools sort -@ ${numcpus} ${outdir}/hisat/${samples[$i]}_htOut.bam -o ${outdir}/hisat/${samples[$i]}_htOut_sorted.bam
 rm ${outdir}/hisat/${samples[$i]}_htOut.sam
 rm ${outdir}/hisat/${samples[$i]}_htOut.bam

 echo "Running first run of stringtie on ""${names[$i]}"
 $Stringtie ${outdir}/hisat/${samples[$i]}_htOut_sorted.bam -p ${numcpus} --rf -G ${gtffile} -A ${outdir}/stringtie/${samples[$i]}.gene.abundance.txt -C ${outdir}/stringtie/${samples[$i]}.coverage.gtf -o ${outdir}/stringtie/${samples[$i]}.transcripts.gtf -v

done

## Merging the transcript files of all samples  (second run of Stringtie)
 echo "Running stringtie merge on all samples "
 $Stringtie --merge -p ${numcpus} --rf -G ${gtffile} -o ${outdir}/stringtie/allsamples_merged_transcriptome.gtf ${outdir}/stringtie/*.transcripts.gtf
 
## Estimating transcript abundance by looping over each sample  
${samples[$i]}
${names[$i]}
for ((i=0; i<${#samples[@]}; i++));
do
 echo "Estimating transcripts abundance for  ""${names[$i]}"
 $Stringtie -e -B -p ${numcpus} -G ${outdir}/stringtie/allsamples_merged_transcriptome.gtf --rf -o ${outdir}/ballgown/${names[$i]}/${names[$i]}.gtf ${outdir}/hisat/${samples[$i]}_htOut_sorted.bam
done
