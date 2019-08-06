%-----------------------------------------------------------------------
% Job saved on 16-Jan-2019 16:42:47 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.exp_frames.files = {'/projects/sanlab/shared/RRV/bids_data/derivatives/fmriprep/sub-RRV001/ses-wave1/func/s6_sub-RRV001_ses-wave1_task-CR_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii,1'};
matlabbatch{1}.spm.util.exp_frames.frames = Inf;
matlabbatch{2}.spm.stats.fmri_spec.dir = {'/projects/sanlab/shared/RRV/nonbids_data/fMRI/fx/models/event/sub-RRV001'};
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2.5;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 36;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{2}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi = {'/projects/sanlab/shared/RRV/RRV_scripts/fMRI/fx/multiconds/event/RRV001_CR_run1.mat'};
matlabbatch{2}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{2}.spm.stats.fmri_spec.sess(1).multi_reg = {'/projects/sanlab/shared/RRV/RRV_scripts/fMRI/fx/motion/auto-motion-fmriprep/rp_txt/rp_RRV001_1_CR_1.txt'};
matlabbatch{2}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
matlabbatch{2}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{2}.spm.stats.fmri_spec.mask = {'/projects/sanlab/shared/spm12/canonical/MNI152lin_T1_2mm_brain_mask.nii,1'};
matlabbatch{2}.spm.stats.fmri_spec.cvi = 'FAST';
