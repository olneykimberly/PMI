#!/bin/bash
#$ -pe threaded 18
#$ -l h_vmem=24G  


# activate conda env
source $HOME/.bash_profile
module load python
conda activate cellbender

# set variable
sample=$1

# print what sample you're on
echo "sample: $sample"

# change directory to your desired output folder
cd /research/labs/neurology/fryer/shared/PMI/scripts/snakemake

# run cellbender with cellranger count raw_feature_bc_matrix.h5 output from each sample
cellbender remove-background \
		   --input /research/labs/neurology/fryer/shared/PMI/cellranger/snRNA/$sample/outs/raw_feature_bc_matrix.h5 \
		   --output /research/labs/neurology/fryer/shared/PMI/cellbender/snRNA/$sample/$sample_cellbender.h5 \
		   --expected-cells 6000 \
		   #--total-droplets-included 20000 \
		   --fpr 0.05 \
		   --epochs 150\


touch $sample

