get_file_paths <- function(path, metadata) {
  fnFs <- (list.files(path, pattern=".R1.fastq", full.names = TRUE))
  fnRs <- sort(list.files(path, pattern=".R2.fastq", full.names = TRUE))
  sample.names <- metadata$sample_ID[match(basename(fnFs), basename(metadata$file))]
  fnFs <- fnFs[!is.na(sample.names)]
  fnRs <- fnRs[!is.na(sample.names)]
  sample.names <- sample.names[!is.na(sample.names)]
  return(list("fnFs" = fnFs, "fnRs" = fnRs, "sample_names"=sample.names))
}

filter_quality <- function(fns_paths, outp) {
  filtFs <- file.path(outp, "01_filtered", paste0(fns_paths[["sample_names"]], "_F_filt.fastq.gz"))
  filtRs <- file.path(outp, "01_filtered", paste0(fns_paths[["sample_names"]], "_R_filt.fastq.gz"))
  names(filtFs) <- fns_paths[["sample_names"]]
  names(filtRs) <- fns_paths[["sample_names"]]
  
  count_denoise <- filterAndTrim(fns_paths$fnFs, filtFs, fns_paths$fnRs, filtRs, #truncLen=c(240,160),
                                 maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
                                 compress=TRUE, multithread=FALSE) # Multicore is not working on RStudio server I am not sure why
  return(list("filtFs"=filtFs, "filtRs"=filtRs, "count_denoise"=count_denoise))
}