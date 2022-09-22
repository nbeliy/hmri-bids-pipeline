function outDataset = mpm_Process(source, destination, varargin)

  args = inputParser();
  args.addParameter('subjects', []);
  args.addParameter('name', 'mpm_Process');

  args.parse(varargin{:});


  % activating logging
  log_path = fullfile(destination, args.Results.name, 'code');
  if ~exist(log_path, 'dir')
    mkdir(log_path);
  end

  try

    crc_generate_log(log_path, 'mpm_Reorient');
    reorient_dataset = mpm_Reorient(source, destination, ...
                                    'subjects', args.Results.subjects, ...
                                    'name', args.Results.name ...
                                    );

    crc_generate_log(log_path, 'mpm_CreateMap');
    map_dataset = mpm_CreateMap(reorient_dataset, destination, ...
                                'subjects', args.Results.subjects, ...
                                'name', args.Results.name ...
                                );

    crc_generate_log(log_path, 'mpm_Dartell');
    pre_dataset = mpm_Dartell(map_dataset, destination, ...
                              'subjects', args.Results.subjects, ...
                              'name', args.Results.name ...
                              );
    outDataset = pre_dataset;
  catch ME
    %fprintf('Error:\n%s\n', ME.getReport);
    diary off;
    rethrow(ME);
  end
  diary off;

end
