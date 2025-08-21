create_asv_metadata <- function(seqtab, outp) {
  asv_metadata <- data.frame(
    "ASV_ID" = paste("ASV", seq(1,nrow(seqtab)), sep="_"),
    "sequence" = rownames(seqtab),
    "abundance" = apply(seqtab, 1, sum),
    "prevalence" = apply(seqtab, 1, function(x) sum(x>0))
  )
  return(asv_metadata)
}