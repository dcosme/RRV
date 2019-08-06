#!/bin/bash
#--------------------------------------------------------------
# This script should be used to run FX con jobs and then 
# calculate ACF parameters. It executes spm_job_residuals.sh
# for $SUB and matlab FX $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set the lab
LAB=sanlab

# Set your study
STUDY=RRV

# Set task name and session pattern
TASK=CR
SES=ses-wave1

# Set subject list
SUBJLIST=`cat test_subject_list.txt`

# Which SID should be replaced?
REPLACESID=001

# SPM Path
SPM_PATH=/projects/sanlab/shared/spm12

# Set scripts directory path
SCRIPTS_DIR=/projects/sanlab/shared/${STUDY}/${STUDY}_scripts

# Set MATLAB script path
SCRIPT=${SCRIPTS_DIR}/fMRI/fx/models/fx_event_cons.m

# Set shell script to execute
SHELL_SCRIPT=spm_job_residuals.sh

# RRV the results files
RESULTS_INFIX=fx_event_cons

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${SCRIPTS_DIR}/fMRI/fx/models/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# model output directory
MODEL_DIR=/projects/sanlab/shared/RRV/nonbids_data/fMRI/fx/models/event

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do

	RES_DIR=${MODEL_DIR}/sub-${STUDY}${SUB}

	sbatch --export ALL,REPLACESID=$REPLACESID,LAB=$LAB,STUDY=$STUDY,TASK=$TASK,SES=$SES,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,RES_DIR=$RES_DIR  \
		--job-name=${RESULTS_INFIX} \
	 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
	 	--cpus-per-task=${cpuspertask} \
	 	--mem-per-cpu=${mempercpu} \
	 	--account=sanlab \
	 	${SHELL_SCRIPT}
		sleep .25
done