fprintf('Generating batch\n');

matlabbatch{1}.spm.tools.hmri.autoreor.reference = {'<UNDEFINED>'};
matlabbatch{1}.spm.tools.hmri.autoreor.template = {fullfile(spm('dir'),...
                                                   'canonical',...
                                                   'avg152PD.nii,1')...
                                                   };
matlabbatch{1}.spm.tools.hmri.autoreor.other = {'<UNDEFINED>'};
matlabbatch{1}.spm.tools.hmri.autoreor.output.indir = 'yes';
matlabbatch{1}.spm.tools.hmri.autoreor.dep = 'individual';
