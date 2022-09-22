function  outDataset = mpm_Dartell(source, destination, varargin)
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

  % This will load bidsified dataset into BIDS structure
  BIDS = bids.layout(source,...
                     'use_schema', false,...
                     'index_derivatives', false,...
                     'tolerant', true);
  DERIV = crc_bids_gen_dervative(BIDS, destination, procStep,...
                                 params.Dartell, subjects);

  codeDir = crc_bids_make_code_dir(outDataset, scrName,...
                                   {params_file,...
                                    crc_local_fnam});

  subjects = bids.query(BIDS,'subjects')';

  tmp_dir = fullfile(outDataset, ['tmp_' procStep]);
  if exist(tmp_dir, 'dir')
    error('Temporary directory from previous run exists');
  end
  mkdir(tmp_dir);

  % Retrieving reference structural images
  params.Dartell.reference.number = size(subjects, 1);
  struct_files = crc_bids_query_data(DERIV, params.Dartell.reference,...
                                     [], 'reference');

  % Getting list of map suffixes for first subject

  maps = {};
  for iSub = 1:size(subjects, 1)
    sub_maps = crc_bids_query_data(DERIV, params.Dartell.maps, ...
                                   subjects{iSub}, [subjects{iSub} ': maps']);
    maps = [maps sub_maps];
  end

  out_maps = cell(size(maps, 1), 1);
  for i = 1:size(maps, 1)
    out_maps{i, 1} = maps(i, :)';
  end

  clear matlabbatch;
  % run(fullfile(pathStep, 'MBatches','batch_Process.m'));
  load(fullfile(pathStep, 'MBatches','batch_Process.m.mat'));
  cmb = 1;
  matlabbatch{cmb}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {crc_local_fnam}; %#ok<*AGROW>

  cmb = 2;
  matlabbatch{cmb}.spm.tools.hmri.proc.proc_pipel.output.outdir = {tmp_dir};
  matlabbatch{cmb}.spm.tools.hmri.proc.proc_pipel.s_vols = struct_files;
  matlabbatch{cmb}.spm.tools.hmri.proc.proc_pipel.vols_pm = out_maps;

  % Saving batch as reference
  save(fullfile(codeDir, [scrName, '.mat']), 'matlabbatch');

  spm_jobman('run',matlabbatch);
  
  for iSub = 1:size(subjects, 1)
    sub_path = fullfile(outDataset, ['sub-' subjects{iSub}], 'Segmented');
    if exist(sub_path, 'dir')
      warning('%s alredy present, it will be emptied!', sub_path);
      rmdir(sub_path, 's');
    end
    % Renaming masks and means
    flist = cellstr(spm_select('List', tmp_dir, '^(mask|mean)_'));
    for i = 1:size(flist, 1)
      if isempty(flist{i})
        break;
      end
      fprintf('%s\n', flist{i});
      f = bids.File(flist{i});
      prefix = strsplit(f.prefix, '_');
      if size(prefix, 2) ~= 2
        warning('%s: prefix %s can''t be split in two parts',...
                flist{i}, f.prefix);
      else
        f.entities.sub = '';
        f.entities.desc = prefix{2};
        f.entities.label = f.suffix;
        f.suffix = prefix{1};
        f.prefix = '';
        movefile(fullfile(tmp_dir, flist{i}),...
                 fullfile(tmp_dir, f.filename()))
      end
    end

    flist = cellstr(spm_select('List', tmp_dir, ['sub-' subjects{iSub}]));
    if size(flist, 1) == 0
      warning('No files to move!');
      continue;
    end
    mkdir(sub_path);
    for i = 1: size(flist, 1)
      movefile(fullfile(tmp_dir, flist{i}), sub_path);
    end
    crc_bids_merge_suffix(sub_path);
  end

  % moving remaining files to template folder
  sub_path = fullfile(outDataset, 'Templates/');
  if exist(sub_path, 'dir')
    warning('%s alredy present, it will be emptied!', sub_path);
    rmdir(sub_path, 's');
  end
  movefile(tmp_dir, sub_path);
end
