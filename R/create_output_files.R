create_asv_metadata <- function(seqtab, outp) {
    asv_metadata <- data.frame(
      "ASV_ID" = paste("ASV", seq(1,nrow(seqtab)), sep="_"),
      "sequence" = rownames(seqtab),
      "abundance" = apply(seqtab, 1, sum),
      "prevalence" = apply(seqtab, 1, function(x) sum(x>0))
    )
    write.csv(asv_metadata, file.path(outp, "ASV_metadata.csv"))
    return(asv_metadata)
}

save_asv_table <- function(seqtab, asv_metadata, outp) {
  rownames(seqtab) <- asv_metadata$ASV_ID
  write.csv(seqtab, file.path(outp, "asv_table_dada2.csv"))
  return(seqtab)
}