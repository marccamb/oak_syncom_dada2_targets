save_outputs <- function(seqtab, asv_metadata, outp) {
  rownames(seqtab) <- asv_metadata$ASV_ID
  write.csv(seqtab, file.path(outp, "asv_table.csv"))
  write.csv(asv_metadata, file.path(outp, "asv_metadata.csv"))
  return(seqtab)
}

