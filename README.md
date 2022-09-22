# Implementation of bids-based pipelines

## Requirements

Official package to work with bidsified datasets.
[bids-matlab](https://github.com/bids-standard/bids-matlab/)
`git clone -b dev git@github.com:bids-standard/bids-matlab.git`

The package can be very slow in current state, hopely will change later.

Some additional utility scripts:
[bids-processing-tools](git@gitlab.uliege.be:CyclotronResearchCentre/Methods/BIDS_Tools/bids-processing-tools.git)
`git clone bids-processing-tools`

Other package may be required, see dedicated `README.md` files.

## Genetal phylosophy

The pipelines tries to streamline the usual image processing and adapt them to BIDS.

Each pipeline contains 2 or 3 configuration folders:

 - `config`: contains `json` files wich defines file selection to process
 - `MBatches`: contains a set of spm-batches files, used by pipeline
 - `ConfigCRC`: used toolbox requires a configuration files, they will be stored there

a set of matalb scripts implementing each individual steps and master script that
runs the full pipeline.

To run the pipeline, user expected to fork the package, and adapt pipeline to his needs.
Adapt file selection in `config/.json` file, adapt batches parameters in `MBatches` and
adapt default configuration files in `ConfigCRC`.

All local changes should be commited only on individual branches or forked
repository.
More general improvments and bug fixes should be integrated into main package
using merge request.

## Individual steps signature

Each individual step in pipeline should be presented as a function,
accepting two positional parameters:

 - `source`: path to source dataset, which is expected to follow BIDS
 - `destination`: path to output directory, where the datasets will
be cloned as derivative dataset

and at least two named optional parameters:

 - `name`: name of processing step, if not specified, will be same
as script name
 - `subjects`: cellstring, containing list of subjects to process,
if not specified, all subjects will be processed

The return value will be the path of derivative dataset.

Step script will load the source dataset, select needed files for processing
and copy them to `<destination>/<name>` derivative dataset.
The following processing will be done only on derived dataset.

**Important**
If `source` is same `destination/name`, then derivative datasets will not be copied,
and processing will be performed on source dataset.

See example in `mpm/mpm_CreateMap`.

## Master script

The master script collect several steps into one processing from a to z.
It has the same signature as individual scripts, and will create only one
derivated dataset.

The terminal output of each individual step will be saved in the log file.

## Configuration

### File selection

Pipeline selects files to process using `bids.query` function from
`bids-matlab` package.
In this package, files are selected by a set of entity key-value pairs.
This selection is configured in `config/.json` files in form of
`query` dictionary, for ex:

```json
    "reference": {
      "query": {
        "modality": "anat",
        "acq": "MTw",
        "echo": "2",
        "part": "mag",
        "suffix": "MPM",
        "extension": [".nii", ".nii.gz"]
      },
      "number": 1
    }
```

Here, for each subject, and image with extention `.nii` or `.nii.gz`,
from modality `anat`, having `acq-MTw` in the name.
The optional parameter `number` provides a number of expected files.
If number of retrieved files differs, pipeline will raise an error and
skip faulty subject.
