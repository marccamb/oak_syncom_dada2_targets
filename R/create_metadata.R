create_metadata <- function(count_file, sample_tags_file) {
  counts_demultiplex <- read.table(count_file)
  names(counts_demultiplex) <- c("file", "nb_read_pairs")
  counts_demultiplex$sample <- gsub("16SV4_revcomp/", "", counts_demultiplex$file)
  counts_demultiplex$sample <- gsub(".R1.fastq.gz", "", counts_demultiplex$sample)
  counts_demultiplex$tags <- gsub(".*DI(.*)-.*_.*DI(.*)", "F\\1 R\\2", counts_demultiplex$sample)
  
  sample_tag <- read.table(sample_tags_file, h=T, sep=",")
  counts_demultiplex$sample_ID <- sample_tag$sample_id[match(counts_demultiplex$tags, sample_tag$tags)]
  counts_demultiplex <- subset(counts_demultiplex, !is.na(sample_ID))
  counts_demultiplex$sample_ID[counts_demultiplex$sample_ID=="neg_ctrl_PCR"] <- c("neg_ctrl_PCR_1", "neg_ctrl_PCR_2")
  return(counts_demultiplex)
}