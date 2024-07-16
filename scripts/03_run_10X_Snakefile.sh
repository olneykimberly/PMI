#!/bin/bash
#SBATCH --job-name=pmi                         
#SBATCH --partition=cpu-short
#SBATCH --nodes=1                                     
#SBATCH --tasks=32                                      
#SBATCH --time=32:00:00 # 8 hours                                
#SBATCH --mem=2G 
#SBATCH -o slurm.pmi.out
#SBATCH -e slurm.pmi.err
#SBATCH --mail-user=olney.kimberly@mayo.edu

# source your bach profile to get your specific settings  
source $HOME/.bash_profile

module load python
conda activate PMI_env

# 1) get read information
#sh 01_sample_read_info.sh

# 2) create config
#python 02_create_10X_config.py

# 3) run snakemake - metaphlan alignment 
snakemake -s Snakefile -j 20 --nolock --latency-wait 15 --rerun-incomplete --keep-incomplete --cluster "sbatch --ntasks 32 --partition=cpu-short --mem=50G -t 30:00:00"
