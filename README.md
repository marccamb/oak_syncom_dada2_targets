
# Amplicon sequencing data analysis for oak SynComs *in vitro* experiments

This repository contains the data processing used in the paper **TITLE** **DOI** (SynCom
stability and coalescence experiment).

This [{targets}](https://books.ropensci.org/targets/) reproducible
pipeline contains amplicon sequencing data processing using
[{dada2}](https://benjjneb.github.io/dada2/). It also generates
`SynCom_stability_data_processing.html`, a Quarto report detailing the
steps of the pipeline.

## Package versions

Package versions are recorded using
[{renv}](https://rstudio.github.io/renv/) and can be restored using
`renv::restore()`.

## Raw data

Raw data can be downloaded at **link** and should be placed in
`data/01_raw_data`. The MD5 for the raw data can be checked from
`data/01_raw_data/MD5.txt`.

## How to run the pipeline

1. `install.packages("renv")` to install {renv} from CRAN
2. `renv::restore()` use this command to install all packages and dependancies for the pipeline
1.  `library(targets)` to load the {targets} package
2.  `tar_manifest()` and `tar_visnetwork()` to check the pipeline for
    correctness.
3.  `tar_make()` similar to run the pipeline.
4.  `tar_read()` to read target output.

### Files

-   `R/` contains the custom function used in the pipeline
-   `_targets.R` contains the pipeline configuration and definition
-   `data/00_metadata/` contains the metadata files used for sequence
    processing
-   `data/00_taxonomy_DB/` contains a custom reference database of 16S
    rRNA gene sequenced obtained by *in silico* PCRs from whole genome
    sequencing data of isolates
-   `data/01_raw_data` contains the MD5 hash for the raw data file. The
    raw data file should be saved in this folder before running the
    pipeline.
-   `data/0[23]*` contain outputs of the pipeline
