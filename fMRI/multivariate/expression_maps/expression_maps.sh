#!/bin/bash

# This script extracts mean parameter estimates and SDs within an map or parcel
# from subject images (e.g. FX condition contrasts). Output is 
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
maps=(craving_regulation_neuralsig reward_uniformity-test_z_FDR_0.01 reward_association-test_z_FDR_0.01 value_uniformity-test_z_FDR_0.01 value_association-test_z_FDR_0.01 craving_uniformity-test_z_FDR_0.01 craving_association-test_z_FDR_0.01 cognitive_control_uniformity-test_z_FDR_0.01 cognitive_control_association-test_z_FDR_0.01) #maps (without file format, specified below as .nii.gz)
images=`echo $(printf "con_%04d.nii\n" {1..30})` #participant images to multiply with maps

# paths
image_dir=/projects/sanlab/shared/RRV/nonbids_data/fMRI/fx/models/event/sub-"${SUB}" #fx directory
map_dir=/projects/sanlab/shared/RRV/nonbids_data/fMRI/maps #expression map directory
output_dir=/projects/sanlab/shared/RRV/RRV_scripts/fMRI/multivariate/expression_maps/dotProducts #dot product output directory

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

# Align images and calculate dot products for each contrast and map
# ------------------------------------------------------------------------------------------
for map in ${maps[@]}; do 
	for image in ${images[@]}; do 
		3dAllineate -source "${map_dir}"/"${map}".nii.gz -master "${image_dir}"/mask.nii -final NN -1Dparam_apply '1D: 12@0'\' -prefix "${map_dir}"/"${SUB}"_aligned_"${map}"
		3dcalc -a "${map_dir}"/"${SUB}"_aligned_"${map}"+tlrc -expr 'step(a)' -prefix "${map_dir}"/"${SUB}"_bin_aligned_"${map}"
		echo "${SUB}" "${map}" "${image}" "unmasked" `3ddot -dodot "${map_dir}"/"${model}"/"${SUB}"_aligned_"${map}"+tlrc "${image_dir}"/"${image}"` >> "${output_dir}"/"${SUB}"_dotProducts.txt
		echo "${SUB}" "${map}" "${image}" "masked" `3ddot -mask "${map_dir}"/"${SUB}"_bin_aligned_"${map}"+tlrc -dodot "${map_dir}"/"${model}"/"${SUB}"_aligned_"${map}"+tlrc "${image_dir}"/"${image}"` >> "${output_dir}"/"${SUB}"_dotProducts.txt
		rm "${map_dir}"/"${SUB}"_aligned_"${map}"+tlrc*
		rm "${map_dir}"/"${SUB}"_bin_aligned_"${map}"+tlrc*
	done
done
