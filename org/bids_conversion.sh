#!/bin/bash

# This script moves and renames data to be in accordance with BIDS,
# and creates .json files with the sequence parameters for fmriprep 

# user inpu: define paths
#------------------------------------------
rrv_dir=~/Desktop/RRV
raw_dir=~/Desktop/RRV/raw
bids_dir=~/Desktop/RRV/bids_data
key_dir=~/Documents/code/sanlab/RRV_scripts/org/key

# change directories to raw_dir
#------------------------------------------
cd $rrv_dir
ls -d * > dirs.txt
dirs=`cat dirs.txt`

# make raw_dir
#------------------------------------------
mkdir $raw_dir

# append study name to subject IDs and move to raw_dir
#------------------------------------------
for i in $dirs; do
	cd $i
	for j in $(ls); do
		mv $j "${raw_dir}"/"${i}"_"${j}"
	done
	cd $rrv_dir
	rm -R $i
done

# rename directories to e.g. RRV001
#------------------------------------------
cd $raw_dir

a=1
for i in $(ls); do 
	new=$(printf "RRV%03d" "$a")
	mv -i -- $i $new
	echo "$i,$new" >> "${key_dir}"/key.csv
	let a=a+1
done

# create bids_data folder structure
#------------------------------------------
for i in $(ls); do
	mkdir -pv "${bids_dir}"/sub-"${i}"/ses-wave1/anat
	mkdir -pv "${bids_dir}"/sub-"${i}"/ses-wave1/func
done

# gzip nifti files
#------------------------------------------
for i in $(ls); do
	gzip $i/*.nii
done

# move and rename files to bids_data
#------------------------------------------
for i in $(ls); do
	mv "${i}"/mprage.nii.gz "${bids_dir}"/sub-"${i}"/ses-wave1/anat/sub-"${i}"_ses-wave1_T1w.nii.gz
	mv "${i}"/bold1.nii.gz "${bids_dir}"/sub-"${i}"/ses-wave1/func/sub-"${i}"_ses-wave1_task-CR_acq-1_bold.nii.gz
	mv "${i}"/bold2.nii.gz "${bids_dir}"/sub-"${i}"/ses-wave1/func/sub-"${i}"_ses-wave1_task-CR_acq-2_bold.nii.gz
done

# make .json files
#------------------------------------------
# dataset description
echo -e "{\n\t\"Name\": \"RRV\",\n\t\"BIDSVersion\": \"1.1.1\"\n}" > "${bids_dir}"/dataset_description.json

# T1w
echo -e "{\n\t\"RepetitionTime\": 0.0082,\n\t\"EchoTime\": 0.0037,\n\t\"FlipAngle\": 8,\n\t\"InversionTime\": 0.9\n}" > "${bids_dir}"/T1w.json

# task
echo -e "{\n\t\"TaskName\": \"CR\",\n\t\"RepetitionTime\": 2.5,\n\t\"EchoTime\": 0.035,\n\t\"FlipAngle\": 90,\n\t\"PhaseEncodingDirection\": \"j\"\n}" > "${bids_dir}"/task-CR_bold.json
