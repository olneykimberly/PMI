# PMI
Single nuclues (sn)RNAseq of Mus musculus (mouse) brains that were either harvested fresh (0 hours) or stored in the refrigerator for 3 hours to mimic a typical human post mortem interval (PMI).
The goal of this experiment is to identify differentially expressed genes (DEGs) within brain cell types between experimental groups: 3 hours versus fresh (0 hours). 

Explore genes among the mouse brain samples in our published [shiny app](https://fryerlab.shinyapps.io/PMI_all_cell_types/)


## Set up conda environment
This workflow uses conda. For information on how to install conda [here](https://docs.conda.io/projects/conda/en/latest/user-guide/index.html)

To create the environment:
```
conda env create -n PMI_env --file PMI.yml

# To activate this environment, use
#
#     $ conda activate PMI_env
#
# To deactivate an active environment, use
#
#     $ conda deactivate PMI_env

```
## single nucleus RNAseq differential expression
We have put together a workflow for inferring differential expression between 3 hours and Fresh (0 hours) using two tools MAST and DESeq2. These tools are publicly available and we ask that if you use this workflow to cite the tools used listed in the table below. 

### 1. Download fastq files and mouse reference genome. Create a reference index. 
The raw fastq files may be obtained from SRA PRJNA723823. Samples were sequenced to ~10k nuclei with 20k reads per nuclei. Information on how to download from SRA may be found [here](https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/). 

Download the Mus musculus (mouse) reference. The version used in this workflow is cellranger's refdata-gex-GRCm39-2024-A 
```
cd reference
wget "https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCm39-2024-A.tar.gz"
```

### 2. Align reads and generate quantification estimates.
First move to the scripts  folder.
```
cd scripts
```
Now run the snakefile. To run multiple samples in parallel use -j and the number of jobs to run.
```
snakemake -s Snakefile
```
The Snakefile aligns the reads using cellranger. The Snakefile additionally performs cellbender for cell calling and to adjust the counts to correct for ambient RNA. Note that scripts 01, 02, and 03 may need to be updated depending on the location of where the raw fastq files and reference genome are stored. 

### 3. preform QC filtering and differntial expression
First, you will need to create a results folder and then sub-directories within the results folder.
```
mkdir results
cd results/
mkidr DEGs UMAP UpSet density dot_plot doublet_finder feature histogram markers nuclei_count pca scatter soupX top_transcripts violin volcanoes
```
Within the scripts folder, run the scripts in numerical order. 
```
R 04_soupx_all_samples.Rmd # SoupX to determine ambient RNA. Ultimately cellbender was used, but we additionally compared with SoupX.
R 05_QC_processing_post_Cellbender.Rmd
R 06_annotations.Rmd
R 07_doublet_removal.Rmd
R 08_annotations_post_doublet_removal.Rmd
R 09_recluster.Rmd
R 10_differential_expression_DESeq.Rmd # pseudobulking 
R 10_differential_expression_MAST.Rmd
R 11_make_DEG_excel_and_volcano_plots.Rmd
R 12_make_shiny.Rmd
R 13_correlation_comparisons.Rmd
```

## Contacts

| Contact | Email |
| --- | --- |
| Kimberly Olney, PhD | olney.kimberly@mayo.edu |
| John Fryer, PhD | fryer.john@mayo.edu |