# Transcript assembly by Stringtie

Transcript assembly is Stringtie can be run in 3 modes:

### 1. Reference only: 
 - Needs only one run of Stringtie using the -G and -e Stringtie options.
 - The output will include the estimates of transcript coverage only for the specified 'reference only' transcripts
 - usage: 
		stringtie sample1.bam -p 40 --rf -G annotation_genes.gtf -e -B -C S1-cov_refs.gtf -A S1-gene_abund.tab -o /path/to/output/S1.transcripts.gtf -v
		stringtie sample2.bam -p 40 --rf -G annotation_genes.gtf -e -B -C S2-cov_refs.gtf -A S2-gene_abund.tab -o /path/to/output/S2.transcripts.gtf -v
		stringtie sample3.bam -p 40 --rf -G annotation_genes.gtf -e -B -C S3-cov_refs.gtf -A S3-gene_abund.tab -o /path/to/output/S3.transcripts.gtf -v 

### 2. Reference guided:
- Needs three runs of Stringtie with the first run using the -G option WITHOUT -e, second run of ‘merge’ followed by Stringtie with -e and -B
- In this mode, the first run of stringtie (with -G and without -e option) predicts transcripts present in each sample with the help of the provided reference annotations. In the second stringtie run with 'merge' option, all the transcripts predicted across the different samples are compared and merged, by providing a list of predicted GTF file from across different samples. In the final run of Stringtie, the abundances for each sample are predicted over the merged transcriptome.
- usage:  
First run of Stringtie on 3 samples:
		stringtie sample1.bam -p 40 --rf -G annotation_genes.gtf -C S1-cov_refs.gtf -A S1-gene_abund.tab -o /path/to/output/S1.transcripts.gtf -v
		stringtie sample2.bam -p 40 --rf -G annotation_genes.gtf -C S2-cov_refs.gtf -A S2-gene_abund.tab -o /path/to/output/S2.transcripts.gtf -v
		stringtie sample3.bam -p 40 --rf -G annotation_genes.gtf -C S3-cov_refs.gtf -A S3-gene_abund.tab -o /path/to/output/S3.transcripts.gtf -v

Second run:
		stringtie --rf --merge -p 36 -G annotation_genes.gtf -o allSamples_merged_rf.gtf /path/to/output/*.transcripts.gtf

Third run:
		stringtie -e -B -p 36 -G allSamples_merged_rf.gtf --rf -o path/to/ballgown-out/S1/S1.gtf sample1.bam
		stringtie -e -B -p 36 -G allSamples_merged_rf.gtf --rf -o path/to/ballgown-out/S2/S2.gtf sample2.bam
		stringtie -e -B -p 36 -G allSamples_merged_rf.gtf --rf -o path/to/ballgown-out/S2/S2.gtf sample3.bam

### 3. De novo:
- Needs three runs of Stringtie with the first run by NOT specifying either of the -G OR -e options, then the second run of ‘merge’, followed by Stringtie with -e and -B
- usage:
First run of Stringtie:
		stringtie sample1.bam -p 40 --rf -o /path/to/output/S1.transcripts.gtf -v
		stringtie sample2.bam -p 40 --rf -o /path/to/output/S2.transcripts.gtf -v
		stringtie sample3.bam -p 40 --rf -o /path/to/output/S3.transcripts.gtf -v
Second run:
		stringtie --rf --merge -p 36 -o allSamples_merged_rf.gtf /path/to/output/*.transcripts.gtf
Third run:
		stringtie -e -B -p 36 -G allSamples_merged_rf.gtf --rf -o path/to/ballgown-out/S1/S1.gtf sample1.bam
		stringtie -e -B -p 36 -G allSamples_merged_rf.gtf --rf -o path/to/ballgown-out/S2/S2.gtf sample2.bam
		stringtie -e -B -p 36 -G allSamples_merged_rf.gtf --rf -o path/to/ballgown-out/S2/S2.gtf sample3.bam


## nf-core/rnaseq 
The available rnaseq pipeline at nf-core (https://nf-co.re/rnaseq/3.14.0/), currently, is set-up to run Stringtie only once on each sample.
The pipeline has a parameter '--stringtie_ignore_gtf' which takes a 'boolean' as value. If the parameter is set as 'True' then Stringtie is run without the annotation gtf file, hence said to perform reference-guided de novo assembly of transcripts.

The parameters defined in this pipeline for Stringtie can be seen here: https://github.com/nf-core/rnaseq/blob/3.14.0/modules/nf-core/stringtie/stringtie/main.nf

stringtie \\
        $bam \\
        $strandedness \\  #can be '--fr' or '--rf' 
        $reference \\     # if '--stringtie_ignore_gtf' is false annotation_gtf is provided
        -o ${prefix}.transcripts.gtf \\  
        -A ${prefix}.gene.abundance.txt \\
        $coverage \\ 
        $ballgown \\
        -p $task.cpus \\
        $args

The per sample result files after the pipeline run are structured as follows: (as mentioned in Ref:https://nf-co.re/rnaseq/3.14.0/docs/output/)
Output files:
	<ALIGNER>/stringtie/
	*.coverage.gtf: GTF file containing transcripts that are fully covered by reads.
	*.transcripts.gtf: GTF file containing all of the assembled transcipts from StringTie.
	*.gene_abundance.txt: Text file containing gene aboundances and FPKM values.
	<ALIGNER>/stringtie/<SAMPLE>.ballgown/: Ballgown output directory.


### The details of the parameters as listed in Stringtie manual (https://ccb.jhu.edu/software/stringtie/index.shtml?t=manual):
		-G <ref_ann.gff>	Use a reference annotation file (in GTF or GFF3 format) to guide the assembly process. The output will include expressed reference transcripts as well as any novel transcripts that are assembled. This option is required by options -B, -b, -e, -C (see below)

		"Note that when a reference transcript is fully covered by input read alignments, the original transcript ID from the reference annotation file will be shown in StringTie's output file in the reference_id GTF attribute for that assembled transcript. Output transcripts lacking the reference_id attribute can be considered "novel" transcript structures with respect to the provided reference annotation."

		-e	this option directs StringTie to operate in expression estimation mode; this limits the processing of read alignments to estimating the coverage of the transcripts given with the -G option (hence this option requires -G).

		-B	This switch enables the output of Ballgown input table files (*.ctab) containing coverage data for the reference transcripts given with the -G option. (See the Ballgown documentation for a description of these files.) With this option StringTie can be used as a direct replacement of the tablemaker program included with the Ballgown distribution.
		If the option -o is given as a full path to the output transcript file, StringTie will write the *.ctab files in the same directory as the output GTF.

		-b <path>	Just like -B this option enables the output of *.ctab files for Ballgown, but these files will be created in the provided directory <path> instead of the directory specified by the -o option. Note: adding the -e option is recommended with the -B/-b options, unless novel transcripts are still wanted in the StringTie GTF output.

		-C <cov_refs.gtf>	StringTie outputs a file with the given name with all transcripts in the provided reference file that are fully covered by reads (requires -G).

		-p <int>	Specify the number of processing threads (CPUs) to use for transcript assembly. The default is 1.

		--rf	Assumes a stranded library fr-firststrand.
		--fr	Assumes a stranded library fr-secondstrand.

		--merge	Transcript merge mode. This is a special usage mode of StringTie, distinct from the assembly usage mode described above. In the merge mode, StringTie takes as input a list of GTF/GFF files and merges/assembles these transcripts into a non-redundant set of transcripts. This mode is used in the new differential analysis pipeline to generate a global, unified set of transcripts (isoforms) across multiple RNA-Seq samples.
		If the -G option (reference annotation) is provided, StringTie will assemble the transfrags from the input GTF files with the reference transcripts.

		The following additional options can be used in this mode:
		-G <guide_gff>	reference annotation to include in the merging (GTF/GFF3)
		-o <out_gtf>	output file name for the merged transcripts GTF (default: stdout)
		-m <min_len>	minimum input transcript length to include in the merge (default: 50)
		-c <min_cov>	minimum input transcript coverage to include in the merge (default: 0)
		-F <min_fpkm>	minimum input transcript FPKM to include in the merge (default: 0)
		-T <min_tpm>	minimum input transcript TPM to include in the merge (default: 0)
		-f <min_iso>	minimum isoform fraction (default: 0.01)
		-i	keep merged transcripts with retained introns (default: these are not kept unless there is strong evidence for them)
		-l <label>	name prefix for output transcripts (default: MSTRG)

