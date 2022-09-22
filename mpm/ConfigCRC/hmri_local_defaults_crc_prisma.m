function hmri_local_defaults_crc_prisma
% PURPOSE
% To set user-defined (site- or protocol-specific) defaults parameters
% which are used by the hMRI toolbox. Customized processing parameters can
% be defined, overwriting defaults from hmri_defaults. Acquisition
% protocols can be specified here as a fallback solution when no metadata
% are available. Note that the use of metadata is strongly recommended. 
%
% RECOMMENDATIONS
% Parameters defined in this file are identical, initially, to the ones
% defined in hmri_defaults.m. It is recommended, when modifying this file,
% to remove all unchanged entries and save the file with a meaningful name.
% This will help you identifying the appropriate defaults to be used for
% each protocol, and will improve the readability of the file by pointing
% to the modified parameters only.
%
% WARNING
% Modification of the defaults parameters may impair the integrity of the
% toolbox, leading to unexpected behaviour. ONLY RECOMMENDED FOR ADVANCED
% USERS - i.e. who have a good knowledge of the underlying algorithms and
% implementation. The SAME SET OF DEFAULT PARAMETERS must be used to
% process uniformly all the data from a given study. 
%
% HOW DOES IT WORK?
% The modified defaults file can be selected using the "Configure toolbox"
% branch of the hMRI-Toolbox. For customization of B1 processing
% parameters, type "help hmri_b1_standard_defaults.m". 
%
% DOCUMENTATION
% A brief description of each parameter is provided together with
% guidelines and recommendations to modify these parameters. With few
% exceptions, parameters should ONLY be MODIFIED and customized BY ADVANCED
% USERS, having a good knowledge of the underlying algorithms and
% implementation. 
% Please refer to the documentation in the github WIKI for more details. 
%__________________________________________________________________________
% Written by E. Balteau, 2017.
% Cyclotron Research Centre, University of Liege, Belgium

% Global hmri_def variable used across the whole toolbox
global hmri_def

% Specify the research centre & scanner. Not mandatory.
hmri_def.centre = 'crc' ; % 'fil', 'lren', 'crc', 'sciz', 'cbs', ...
hmri_def.scanner = 'prisma' ; % e.g. 'prisma', 'allegra', 'terra', 'achieva', ...

%==========================================================================
% Common processing parameters 
%==========================================================================

% cleanup temporary directories. If set to true, all temporary directories
% are deleted at the end of map creation, only the "Results" directory and
% "Supplementary" subdirectory are kept. Setting "cleanup" to "false" might
% be convenient if one desires to have a closer look at intermediate
% processing steps. Otherwise "cleanup = true" is recommended for saving
% disk space.
hmri_def.cleanup = true;

%==========================================================================
% R1/PD/R2s/MT map creation parameters
%==========================================================================

%--------------------------------------------------------------------------
% quantitative maps: quality evaluation and realignment to MNI
%--------------------------------------------------------------------------
% creates a matlab structure containing markers of data quality
% eb: can be set to 0 to save processing time, currently output not used...
hmri_def.qMRI_maps.QA          = 1; 

%--------------------------------------------------------------------------
% MPM acquisition parameters and RF spoiling correction parameters
%--------------------------------------------------------------------------
% We want ISC applied to Prisma data (CRC)
hmri_def.imperfectSpoilCorr.enabled = true;

end
