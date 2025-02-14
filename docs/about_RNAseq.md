# About RNAseq

## Objectives:

1) To know what is expressed. i.e. annotate the transcripts, exon-intron boundaries, transcriptional start sites, poly A sites - (obtain Qualitative data)
		- aim is to have reads that are mapped to the rare, lowly expressed transcripts
		- have coverage along the whole read. 
		- long read sequencing, paired-end sequencing and stranded-library preparation methods are preferred. 
		- can have DSN normalization which reduces the reads from highly expressed genes, thas having reads from rarer, lowly expressed transcripts.
		(Third generation sequencer PacBio provides long read sequencing)

2) To know how much is expressed . i.e. to compare difference in expression of transcripts between conditions.
- to identify differentially expressed genes and the magnitude by which they vary - significtly enriched (degree of difference)
- to find variance within and between the groups

## RNAseq counts follow negative binomial distribution (Normalization)

- The first strand of cDNA from an mRNA is sequenced using Reverse transcriptase, and the second strand is sequenced using DNA polymease 
- Both the strand sequencing requires primers to initiate sequencing.
- using oligo-dT to prime synthesis of polyA tail - to use random primers that can attach anywhere on the transcript.

## Parameters for RNAseq experiment:
i)   Replicates
- number of replicates that need to be acquired depends on the aim of experiment. necessary if doing DGE and can be wavered if the aim is annotation.
- depends on effect size of genes in a condition that is tested, significance threshold at which true positives are determined.

ii)  Coverage
iii) Depth

iv) Effect size vs sample size
- is the difference between the groups.
- small effect size and large number of sample : if the difference between the means of 2 distrubtions being compared (Condition 1 and 2) is very less.. i.e. there is a significant overlap between the 2 distributions. In this case large number of samples are required for statistical testing.
- large effect size and few samples: if the difference in the group means of two conditions is large and there is less overlap between the 2 distributions, it means having larger effect size. For statistical tests between these treatments one can start with fewer samples.
-Effect size depends on the amount and quality of RNA extracted and the nuceotides(dNTPs) added in the sequencer (coverage). It also depends on the depth of sequencing.


## Power of RNAseq experiment
In reference to RNAseq study designs, power refers to the ability to detect differentially expressed gene (or transcript) when it is truly differentially expressed.
i.e. the ability to detect a true positive while avoiding false negatives.

		Power = 1 - beta
		where beta is Probability of type II error (which is failing to detect a true DE gene)

Power depends on following multiple parameters:
1) Effect size: which is the magnitude of difference in expression, between the condition that are being compared. 
2) Dispersion: Biological variability in expression between replicates.
3) Sample size: Number of biological replicates per condition
4) Sequencing depth/coverage:  number of sequenced reads per sample
5) Significance threshold: Cutoff value for detecting differential expression

Power can be caluclated by:
- In R using the package RnaSeqSampleSize
- another R package: PROPER
- Scotty - a web absed tool



FDR - 

False negative - type II error - failure to reject null hypothesis of no difference when there is actually a difference
Statistical power - 1 - beta (beta - used to symbolize occurence of type II errors)

False Positive - type I error - reject null hypothesis in favour of alternative when the null hypothesis is actually true. 

FDR

alternative TSS

alternative polyadneylation sites


- Bioanalyser to evaluate RNA integrity, to check if the sample is degraded

## To enrich specific classes of RNA from total-RNA isolate.
- polyA enrichment - to selectively isolate mature mRNA by duplexing with their poly-A tail using oligo-dT
- to selectively sequence only the 3' end of poly-A transcripts using SuperSAGE. 
- selectively depleting rRNA using oligos complementary to highly conserved rRNA sequences (poly-A and immature RNA's which are non poly-A and other RNA classes are retained)
- selecting for size by electophoresis through agaorise or acrymalide gel (solid phase extraction)
- copy number normalization using duplex-specific nuclease digestion



