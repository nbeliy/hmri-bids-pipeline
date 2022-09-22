%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function can be used to segment all maps     %
% that you have created using "Create_map" function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Generating batch\n')

% generating templates paths
hmri_template_path = fileparts(which('tbx_cfg_hmri'));
hmri_template_base = fullfile(hmri_template_path, 'etpm', 'eTPM.nii');


% Defaults config, in case of prisma
cmb = 1;
matlabbatch{cmb}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {'<UNDEFINED>'};

cmb = 2;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.output.outdir = {'<UNDEFINED>'};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.channel.vols = {'<UNDEFINED>'};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.channel.biasreg = 0;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.channel.biasfwhm = Inf;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.channel.write = [0 0];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.vols_pm = {};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.vox = [1 1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.bb = [-78 -112 -70
                                                                        78 76 85];

% tissues
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(1).tpm = {[hmri_template_base ',1']};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(1).ngaus = 2;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(1).native = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(1).warped = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(2).tpm = {[hmri_template_base ',2']};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(2).ngaus = 2;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(2).native = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(2).warped = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(3).tpm = {[hmri_template_base ',3']};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(3).ngaus = 2;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(3).native = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(3).warped = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(4).tpm = {[hmri_template_base ',4']};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(4).ngaus = 3;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(4).native = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(4).warped = [0 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(5).tpm = {[hmri_template_base ',5']};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(5).ngaus = 4;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(5).native = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(5).warped = [0 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(6).tpm = {[hmri_template_base ',6']};
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(6).ngaus = 2;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(6).native = [1 1];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.tissue(6).warped = [0 1];

matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.mrf = 1;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.cleanup = 1;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.affreg = 'mni';
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.fwhm = 0;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.samp = 3;
matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.warp.write = [0 1];
