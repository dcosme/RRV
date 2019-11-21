#!/bin/bash

# This script extracts mean parameter estimates and SDs within an ROI or parcel
# from subject FX condition contrasts (condition > rest) for each wave. Output is 
# saved as a text file in the output directory.

module load afni

echo -------------------------------------------------------------------------------
echo "${SUB}"
echo "Running ${SCRIPT}"
date
echo -------------------------------------------------------------------------------


# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
cons=`echo $(printf "con_%04d.nii\n" {1..30})` #contrasts to extract parameter estimates from
radius=6 #mm sphere

# paths
con_dir=/projects/sanlab/shared/RRV/nonbids_data/fMRI/fx/models/event/sub-"${SUB}" #con directory
output_dir=/projects/sanlab/shared/RRV/RRV_scripts/fMRI/roi/parameterEstimates #parameter estimate output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

# Extract mean parameter estimates and SDs for each subject, wave, contrast, and roi/parcel
# ------------------------------------------------------------------------------------------
for con in ${cons[@]}; do 
	while read roi; do 
		echo "${SUB}" "${con}" "${roi}" `3dmaskave -sigma -quiet -nball $(echo "${roi}") $(echo "${radius}") "${con_dir}"/"${con}"` >> "${output_dir}"/"${SUB}"_parameterEstimates.txt
	done <rois.txt
done