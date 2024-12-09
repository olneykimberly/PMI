#!/bin/bash                         
#SBATCH --partition=gpu                                    
#SBATCH --time=40:00:00 # 8 hours                                
#SBATCH --mem=25G
#SBATCH --mail-user=olney.kimberly@mayo.edu
#SBATCH --tasks=32                                      

# activate conda env
source $HOME/.bash_profile
module load python
conda activate cellbender_v0.3.0

# set variable
sample=$1

# print what sample you're on
echo "sample: $sample"

# change directory to your desired output folder
cd /research/labs/neurology/fryer/m239830/PMI/cellbender/
#mkdir $sample/
cd $sample/

# run cellbender with cellranger count raw_feature_bc_matrix.h5 output from each sample
cellbender remove-background \
		   --cuda \
		   --input ../../cellranger/$sample/outs/raw_feature_bc_matrix.h5 \
		   --output $sample_cellbender.h5 \
		   --checkpoint ckpt.tar.gz

touch $sample_cellbender.h5
