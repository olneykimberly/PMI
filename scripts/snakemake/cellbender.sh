#!/bin/bash

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
		   --input /research/labs/neurology/fryer/shared/PMI/cellranger/scRNA/$sample/outs/raw_feature_bc_matrix.h5 \
		   --output /research/labs/neurology/fryer/shared/PMI/cellbender/scRNA/$sample_cellbender.h5 \
		   --expected-cells 6000 \
		   --total-droplets-included 11000 \
		   --fpr 0.01 0.05 0.1 \
		   --epochs 150

