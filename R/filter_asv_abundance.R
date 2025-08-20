filt_asv_abundance <- function(seqtab, seuil) {
  asv_abundance <- apply(seqtab, 1, sum)
  seqtab[asv_abundance > seuil, ]
}