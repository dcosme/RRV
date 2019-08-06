%-----------------------------------------------------------------------
% Job saved on 29-Dec-2018 16:53:58 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat = {'/projects/sanlab/shared/RRV/nonbids_data/fMRI/fx/models/event/sub-RRV001/SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'Snack > Rest';
matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0];
matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = 'Meal > Rest';
matlabbatch{2}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0];
matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.name = 'Dessert > Rest';
matlabbatch{2}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0];
matlabbatch{2}.spm.stats.con.consess{3}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.name = 'Nature > Rest';
matlabbatch{2}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0];
matlabbatch{2}.spm.stats.con.consess{4}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.name = 'Social > Rest';
matlabbatch{2}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1];
matlabbatch{2}.spm.stats.con.consess{5}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.name = 'Food > Rest';
matlabbatch{2}.spm.stats.con.consess{6}.tcon.weights = [1/3 1/3 1/3 0 0];
matlabbatch{2}.spm.stats.con.consess{6}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{7}.tcon.name = 'Snack > Nature';
matlabbatch{2}.spm.stats.con.consess{7}.tcon.weights = [1 0 0 -1 0];
matlabbatch{2}.spm.stats.con.consess{7}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{8}.tcon.name = 'Meal > Nature';
matlabbatch{2}.spm.stats.con.consess{8}.tcon.weights = [0 1 0 -1 0];
matlabbatch{2}.spm.stats.con.consess{8}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{9}.tcon.name = 'Dessert > Nature';
matlabbatch{2}.spm.stats.con.consess{9}.tcon.weights = [0 0 1 -1 0];
matlabbatch{2}.spm.stats.con.consess{9}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.consess{10}.tcon.name = 'Food > Nature';
matlabbatch{2}.spm.stats.con.consess{10}.tcon.weights = [1/3 1/3 1/3 -1 0];
matlabbatch{2}.spm.stats.con.consess{10}.tcon.sessrep = 'both';
matlabbatch{2}.spm.stats.con.delete = 1;
