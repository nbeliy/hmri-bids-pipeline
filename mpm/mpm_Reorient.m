function  outDataset = mpm_Reorient(source, destination, varargin)

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

  % This will load bidsified dataset into BIDS structure
  BIDS = bids.layout(source,...
                     'use_schema', false,...
                     'index_derivatives', false,...
                     'tolerant', true);
  DERIV = crc_bids_gen_dervative(BIDS, destination, procStep,...
                                 params.Reorient, subjects);

  codeDir = crc_bids_make_code_dir(outDataset, scrName, {params_file});

  % getting list of subjects
  subjects = bids.query(DERIV,'subjects');

  for iSub = 1:numel(subjects)

    sub = subjects{iSub};

    fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
    fprintf('Processing subject %d/%d %s\n', iSub, numel(subjects), sub);
    fprintf('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');

    try
      data = crc_bids_query_data(DERIV, params.Reorient.images, sub, 'images');
      ref = crc_bids_query_data(DERIV, params.Reorient.reference, sub, 'reference');

      clear matlabbatch
      %run(fullfile(pathStep, 'MBatches','batch_reorient.m'));
      load(fullfile(pathStep, 'MBatches','batch_reorient.m.mat'))

      matlabbatch{1}.spm.tools.hmri.autoreor.reference = ref(1);
      matlabbatch{1}.spm.tools.hmri.autoreor.other = data;

      % Saving batch as reference
      save(fullfile(codeDir, ['sub-', sub, '_' , scrName, '.mat']), 'matlabbatch');

      spm_jobman('run',matlabbatch);

    catch ME
      warning('Subject %s failed:\n%s', sub, ME.message);
      rethrow(ME);
    end
  end
end

