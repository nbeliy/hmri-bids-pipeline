function  outDataset = mpm_CreateMap(source, destination, varargin)
  % Switching off removal confirmation for octave
  if exist('confirm_recursive_rmdir', 'builtin')
    confirm_recursive_rmdir(0, 'local');
  end

  subjects = [];

  % path and name of current script
  [pathStep, scrName] = fileparts(mfilename('fullpath'));
  procStep = scrName;

  % Global constants and definitions
  params_file = fullfile(pathStep, 'config', 'mpm.json');
  params = spm_jsonread(params_file);

  for ii = 1:2:size(varargin, 2)
    if strcmp(varargin{ii}, 'subjects')
      subjects = varargin{ii + 1};
    elseif strcmp(varargin{ii}, 'name')
      procStep = varargin{ii + 1};
    else
      error(['Unrecognised option ' varargin{ii}]);
    end
  end

  outDataset = fullfile(destination, procStep);

  % Defining paths and default files
  crc_local_fnam = fullfile(pathStep, 'ConfigCRC',...
                            'hmri_local_defaults_crc_prisma.m');
  crc_localb1_fnam = fullfile(pathStep, 'ConfigCRC',...
                              'hmri_b1_local_defaults_crc_prisma.m');

  % This will load bidsified dataset into BIDS structure
  BIDS = bids.layout(source,...
                     'use_schema', false,...
                     'index_derivatives', false,...
                     'tolerant', true);
  DERIV = crc_bids_gen_dervative(BIDS, destination, procStep,...
                                 params.CreateMap, subjects);

  codeDir = crc_bids_make_code_dir(outDataset, scrName,...
                                   {params_file,...
                                    crc_local_fnam, crc_localb1_fnam});

  % getting list of subjects
  subjects = bids.query(DERIV, 'subjects');

  for iSub = 1:numel(subjects)

    sub = subjects{iSub};

    fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
    fprintf('Processing subject %d/%d %s\n', iSub, numel(subjects), sub);
    fprintf('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');

    try
      data = crc_bids_retrieve_data(DERIV, params.CreateMap, sub);

      % interlacing B1 maps
      B1 = [data.B1_map_echo1'; data.B1_map_echo2'];
      B1 = B1(:);

      % combining B0 maps
      B0 = [data.B0_map_mag; data.B0_map_phase];

      data_path = fullfile(fileparts(B1{1}), '..');
      batch_results_path = fullfile(data_path, 'Results');
      results_path = fullfile(data_path, 'MPMmaps');
      suppl_path = fullfile(data_path, 'MPMmapsSupl');
  
      if exist(batch_results_path, 'dir')
        rmdir(batch_results_path, 's');
      end

      if exist(results_path, 'dir') || exist(suppl_path, 'dir')
        warning('Results folders already present');
        continue;
      end

      clear matlabbatch;
      % run(fullfile(pathStep, 'MBatches','batch_CreateMap.m'));
      load(fullfile(pathStep, 'MBatches','batch_CreateMap.m.mat'));

      cmb = 1;
      matlabbatch{cmb}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {crc_local_fnam}; %#ok<*AGROW>
      
      % Then create maps
      cmb = 2;

      % loading defaults for b1
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1parameters.b1defaults = {crc_localb1_fnam};

      % Feeding files
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1input = B1;
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b0input = B0;

      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = data.MTw_images;
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD = data.PDw_images;
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 = data.T1w_images;
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.popup = false;
      matlabbatch{cmb}.spm.tools.hmri.create_mpm.subj.output.outdir = {data_path};

      % Saving batch as reference
      save(fullfile(codeDir, ['sub-', sub, '_' , scrName, '.mat']), 'matlabbatch');

      spm_jobman('run',matlabbatch);

      fprintf('Moving supplementary files to mapSuppl');
      movefile(fullfile(batch_results_path, 'Supplementary'), suppl_path);
      crc_bids_merge_suffix(suppl_path);

      fprintf('Moving results files to maps');
      movefile(batch_results_path, results_path);
      crc_bids_merge_suffix(results_path);

    catch ME
      warning('Subject %s failed:\n%s', sub, ME.message);
      continue;
    end
  end
end
