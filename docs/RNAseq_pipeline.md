# Steps in analysing RNAseq data

Broad steps in any RNAseq pipeline:
1) Filtering the sequenced reads
2) Alignment and Assembly
   Reference based- Aligning the reads to a reference genome
   Denovo based - Assembling the reads to a transcript
3) Annotating the putative transcripts
4) Quantifying the number of reads per transcript
5) Differential expression analysis- statistically compare the abundances of transcripts between conditions 
6) Gene set enrichment analysis/ pathway enrichment analysis 

Types of Sequencer:
PacBio sequencer is able to generate a full, novel transcript with each read produced on the platform.
Illumina, SOLiD :shorter, higher coverage RNAseq data
Rocher 454: long reads, low depth

## 1) Preprocessing the reads
Tools available: Cutadapt, Trimmomatics, trim-galore
		- demultiplex the reads by index or a barcode used to differentiate between the samples that are sequenced together. The barcodes are usually added during the adapter ligation or PCR amplification step.
		
		- remove adapters: if the insert sizes are small and the read lengths are longer, than it is possible to generate reads that have adapters at their 3'-end,
				
		- trim/filter reads having low-quality bases - Illumina reads are known to have poor quality bases towards 3' end fo a read. Bases having low phred scores due to ambuiguity in the base call are usually trimmed off. Reference based assembly is tolerant to base errors whereas denovo based assembly expects cleaner reads.   
		
		Phred quality score = -10 * log10(P); where P is probability of an erroneous base call
		
		Phred quality score - Probability of incorrect base call - Base call accuracy
				10 - 1 in 10        - 90%
				20 - 1 in 100       - 99%
				30 - 1 in 1000      - 99.9%
				40 - 1 in 10000     - 99.99%
				  
				  
		-( k-mer filtering and normalization )

FASTQC - Per base sequence squality
       - per sequence quality score
       - Per base sequence content
       - per sequence GC content
       - sequence duplication
       - over represented sequences
       

## 2) Alignemnet and assembly

### i.  Denovo based assembly
- long read length, paired-end sequencing, with larger depth helps in denovo transcriptome assembly
- based on de Brujin graph-based assembly
- each read is broken into constituent substrings of length k , i.e. genrate k-mers

Common softwares for denovo assembly: Velvet/Oases, Trans-ABySS, Trinity


### ii. Reference based assembly

Errors with Reference genome - can have mis-assemblies, missing information and repetitive regions

1. Build reference index
2. Map reads

For samples with higher depth, reads can be divided into multiple files and alignment can be run in parallel over multiple computing nodes.

When mapping the reads to the reference genome, the aligner should be able to perform gapped-alignment. As the reads generated from mature mRNA does not have introns and may span exon boundaries. The gapped-aligners thus require an annotation file (gff/gtf) which has information about exon-intron boundaries. 

Reads can also be mapped to an assembled transcriptome, and in that case does not require the information about exon-intron boundaries. But transcriptome between tissues might vary, hence a need to have transcriptome, build from various tissues, over different conditions. 

## Different types of available tools

##### "NOTE: Until recently, the standard approach for RNA-seq analysis has been to map our reads using a splice-aware aligner (i.e STAR) and then use the resulting BAM files as input to counting tools like featureCounts and htseq-count to obtain our final expression matrix. The field has now moved towards using lightweight alignment tools like Salmon as standard practice, and so we only use STAR for generating a BAM file. If you are interested in knowing more about the standard approach we have some materials linked here." (Ref:https://github.com/hbctraining/Intro-to-rnaseq-fasrc-salmon-flipped/blob/master/lessons/10_QC_Qualimap.md )

### Aligners:

1) Create reference index (reference genome index, or reference transcriptome index)
2) Quasi-mapping and quantification 

STAR, HISAT2 - base to base alignment of reads to reference genome
SALMON, KALLISTO - lightweight,faster - quasi mapping approach that aligns reads to transcriptome and uses Expectation-Maximization approach to quantify abundance (Salmon for gene level, Sleuth for transcript level).

Salmon's parameter --seqBias enables the model to learn and correct for sequence-specific biases in the input data (which can be GC bias (--gcBias), (--posBias) positional coverage bias, sequence at 5' and 3' ends of fragments, fragment length distribution, strand-specific methods)

##### "NOTE: Since we are searching against only the transcripts (transcriptome), Salmon would not be the appropriate tool to use if trying to detect novel genes or isoforms or other methods that require a well annotated whole genome instead of only the transcriptome." (Ref:https://github.com/hbctraining/Intro-to-rnaseq-fasrc-salmon-flipped/blob/master/lessons/10_QC_Qualimap.md )

##### "NOTE: If there are k-mers in the reads that are not in the index, they are not counted. As such, trimming is not required when using this method. Accordingly, if there are reads from transcripts not present in the reference transcriptome, they will not be quantified. Quantification of the reads is only as good as the quality of the reference transcriptome. " (Ref:https://github.com/hbctraining/Intro-to-rnaseq-fasrc-salmon-flipped/blob/master/lessons/10_QC_Qualimap.md )

### Quality Control

#### (1) STAR/Qualimap - 
 - Read alignment summary
 - read genomic origin
 - coverage across reference
 - genome fraction coverage
 - transcript coverage profile
 - insert size histogram
 
####
reads mapped uniquely - good quality sample have atleast 75% reads uniquely mapped
 
 
### MultiQC -  Documenting results and gathering QC metrics

### BAM file can be visualised in IGV
 
 - junction analysis
 

