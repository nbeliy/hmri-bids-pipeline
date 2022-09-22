function  outDataset = mpm_Segmentation(source, destination, varargin)

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

  BIDS = bids.layout(source,...
                     'use_schema', false,...
                     'index_derivatives', false,...
                     'tolerant', true);
  DERIV = crc_bids_gen_dervative(BIDS, destination, procStep,...
                                 params.Segmentation, subjects);

  codeDir = crc_bids_make_code_dir(outDataset, scrName,...
                                   {params_file,...
                                    crc_local_fnam});

  % getting list of subjects
  subjects = bids.query(DERIV,'subjects');

  for iSub = 1:numel(subjects)

    sub = subjects{iSub};

    fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
    fprintf('Processing subject %d/%d %s\n', iSub, numel(subjects), sub);
    fprintf('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');

    try

      maps = crc_bids_query_data(DERIV, params.Segmentation.maps, ...
                                 sub, 'maps');

      data_path = fullfile(fileparts(maps{1}), '..');
      results_path = fullfile(data_path, 'Segmented/');

      if ~exist(results_path, 'dir')
        mkdir(results_path);
      else
        warning('Directory %s already exists, skipping subject', results_path);
        continue;
      end

      clear matlabbatch;
      run(fullfile(pathStep, 'MBatches','batch_Segmentation.m'));

      cmb = 1;
      matlabbatch{cmb}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {crc_local_fnam}; %#ok<*AGROW>
      
      % Then create maps
      cmb = 2;
      % Feeding files
      matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.output.outdir = {results_path};
      matlabbatch{cmb}.spm.tools.hmri.proc.proc_modul.proc_us.many_sdatas.channel.vols = maps;

      % Saving batch as reference
      save(fullfile(codeDir, ['sub-', sub, '_' , scrName, '.mat']), 'matlabbatch');

      spm_jobman('run',matlabbatch);

      crc_bids_merge_suffix(results_path);

      fprintf('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');
    catch ME
      warning('Subject %s failed:\n%s', sub, ME.getReport('extended'));
      continue;
    end
  end
end
