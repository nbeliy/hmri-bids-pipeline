fprintf('Generating batch\n')

% Defaults config, in case of prisma
cmb = 1;
matlabbatch{cmb}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {'<UNDEFINED>'};

cmb = 2;
matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_us = '-';
matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1input = {'<UNDEFINED>'};
matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b0input = {'<UNDEFINED>'};
matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = {'<UNDEFINED>'};
matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD = {'<UNDEFINED>'};
matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 = {'<UNDEFINED>'};
