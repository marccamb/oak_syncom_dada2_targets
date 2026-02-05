# Created by use_targets().

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(quarto)

# Set target options:
tar_option_set(
  packages = c("dada2", "ggplot2")
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package.
  # For the cloud, see plugin packages like {crew.aws.batch}.
  # The following example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     # Number of workers that the pipeline can scale up to:
  #     workers = 10,
  #     # It is recommended to set an idle time so workers can shut themselves
  #     # down if they are not running tasks.
  #     seconds_idle = 120,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.2".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Define the input and output path
input <- "data/02_sample_demultiplexing/16SV4_revcomp"
outp <- "data/03_dada2_data_processing"
## This is the path of the count file generated with src/src_count_demultiplexed_reads.sh
path_count_file <- "data/02_sample_demultiplexing/count_demultiplexed.txt"
path_sample_tags_file <- "data/00_metadata/sample_tags.csv"
taxo_db_path <- "data/00_taxonomy_DB/insilico_PCR/blastDB_16SV4"

list(
  # Get the name of the count file
  tar_target(count_file, 
             path_count_file,
             format = "file"),
  # Get the name of the count file
  tar_target(sample_tags_file, 
             path_sample_tags_file,
             format = "file"),
  # Read and process the count file
  tar_target(metadata, 
             create_metadata(count_file, sample_tags_file)), # This adds some metadata, this is not great to reuse the pipeline
  # Plot the counts 
  tar_target(fig_read_counts_demultiplex, 
             plot_read_counts(metadata)), 
  # Defining paths and filtering reads
  tar_target(demultiplex_paths, 
             get_file_paths(input, metadata)),
  tar_target(filt_paths, 
             filter_quality(demultiplex_paths, outp)),
  # Learning errors and denoising sequences
  tar_target(dadas, 
             denoise(filt_paths)),
  # Merge-paired end reads
  tar_target(mergers, 
             mergePairs(dadas[["dadaFs"]], filt_paths[["filtFs"]], 
                        dadas[["dadaRs"]], filt_paths[["filtRs"]], 
                        verbose = TRUE)),
  # Create seqtab 
  tar_target(seqtab, 
             t(makeSequenceTable(mergers))),
  # Plot and inspect sequence length
  tar_target(fig_seqlength, 
             plot_sequence_length(seqtab)),
  # Filter ASVs based on their length
  tar_target(seqtab_filt, 
             filt_seq_length(seqtab, seuil = c(230, 270))),
  # Remove chimera
  tar_target(seqtab_filt_nochim, 
             remove_chimera(seqtab_filt)),
  # Remove low abundance ASVs
  tar_target(seqtab_filt_nochim_abund, 
             filt_asv_abundance(seqtab_filt_nochim, seuil = 1000)),
  # Track read loss
  tar_target(read_loss, 
             track_read_loss(filt_paths[["count_denoise"]], 
                             dadas[["dadaFs"]], 
                             mergers, 
                             seqtab_filt, 
                             seqtab_filt_nochim,
                             seqtab_filt_nochim_abund)),
  # Plot read loss
  tar_target(fig_read_loss, plot_read_loss(read_loss)),
  # Rename ASV create ASV_metadata
  tar_target(asv_metadata, 
             create_asv_metadata(seqtab_filt_nochim_abund, outp)),
  ## Assign taxonomy
  tar_target(asv_metadata_taxo, assign_taxo(asv_metadata, taxo_db_path, perc_ident = 98)),
  # Save rename ASVs in the seqtab and produce asv_table output
  tar_target(seqtab_final, 
             save_outputs(seqtab_filt_nochim_abund, asv_metadata_taxo, outp)),
  ## Generation of the quarto report
  tar_quarto(report, "SynCom_stability_data_processing.qmd") # Here is our call to tar_quarto()
)
