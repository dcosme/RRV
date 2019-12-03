#!/bin/bash
#
#SBATCH --job-name=bmi_dots_hpc
#SBATCH --output=bmi_dots_hpc.log
#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=28
#SBATCH --partition=ctn
#SBATCH --mem-per-cpu=20G
#SBATCH --account=sanlab

module load R

Rscript --verbose bmi_dots_hpc.R
