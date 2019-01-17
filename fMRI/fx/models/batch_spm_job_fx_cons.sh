#!/bin/bash
#--------------------------------------------------------------
# This script should be used to run FX con jobs and then 
# calculate ACF parameters. It executes spm_job_residuals.sh
# for $SUB and matlab FX $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------


# Set your study
STUDY=RRV

# Set subject list
SUBJLIST=`cat subject_list.txt`

# Which SID should be replaced?
REPLACESID='001'

# SPM Path
SPM_PATH=/projects/dsnlab/dcosme/SPM12

# Set scripts directory path
SCRIPTS_DIR=/projects/dsnlab/dcosme/${STUDY}/${STUDY}_scripts

# Set MATLAB script path
SCRIPT=${SCRIPTS_DIR}/fMRI/fx/models/CR/wave1/fx_event_noderiv_cons.m

# Set shell script to execute
SHELL_SCRIPT=spm_job_residuals.sh

# RRV the results files
RESULTS_INFIX=fx_event_noderiv_cons

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${SCRIPTS_DIR}/fMRI/fx/models/CR/wave1/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# N runs for residual calculation
RUNS=(1 2)

# model output directory
MODEL_DIR=/projects/dsnlab/dcosme/RRV/nonbids_data/fMRI/fx/models/CR/wave1/event_noderiv

# Make text file with residual files for each run
echo $(printf "Res_%04d.nii\n" {1..122}) > residuals_run1.txt
echo $(printf "Res_%04d.nii\n" {123..244}) > residuals_run2.txt

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do

	RES_DIR=${MODEL_DIR}/sub-${STUDY}${SUB}

	sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,RES_DIR=$RES_DIR  \
		--job-name=${RESULTS_INFIX} \
	 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
	 	--cpus-per-task=${cpuspertask} \
	 	--mem-per-cpu=${mempercpu} \
	 	${SHELL_SCRIPT}
		sleep .25
done
