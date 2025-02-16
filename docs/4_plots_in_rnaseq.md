# Different types of plots to visualize the quality of NGS data

## MA plot
- The plot shows distribution of reads between 2 conditions to identify systematic bias.
- It tells if there is a need of normalization is required for the datasets
- highlights differentially expressed genes
- is a scatter plot with logged intensity ratio (M) on Y-axis and the mean logged intensities (A) on X-axis
- When comparing 2 conditions (control and treatment) each having 3 replicates,
	For each gene/transcript:
	M = log2(T/C) = log2(T) - log2(C)  = log ratio of the expression between 2 conditions
	A = 1/2log2(TC) == 1/2(log2T + log2C) =  log average between the conditions
- Normal expectation is: Most of the genes have lower expression (A)  and high variance (M) (i.e. max points towards left and scattered along Y axis). And as the expression increases (A), the variability in the expression decreases. The plot tightens (tapers) towards left.
- Underlying asssumption (observation) is that most of the genes do not have difference in expression between conditions. i.e. majority of points would be at 0 (coz log2FC on y-axis. i,e log2(1) is 0). 
- datapoints lying away from 0 and indicate having higher fold change. when plotted T/C , points above the line indicate upregulated and below the line indicate data that are downregulated (i.e. negative logaithmic foldchange ratio). 
- The pointa significantly different (high fC) are indicated with color red 

If the plot for you dataset does not have the expected MA relationship:
- it might indicate there is a need of normalization (If the red line is not straight parallel to X-axis at value 0)
- it might indicate variability in dataset (in either or both the conditions) and need to check for outliers or batch effects using PCA. (when most of the data is towards the centre, have high FC, but are not significantly different)

Tools that can be used to visualize the data in MA plot:
DESeq2::plotMA()


Reference:
https://www.biostars.org/p/9466743/
https://hemtools.readthedocs.io/en/latest/content/Bioinformatics_Core_Competencies/MA-plot.html
https://rnaseq.uoregon.edu/

## volcano plot
Y axis = -log 10 adjusted p-value
X axis = log 2 fold change

## PCA
- batch effect
- PCA 
