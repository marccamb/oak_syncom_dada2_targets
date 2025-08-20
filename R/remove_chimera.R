remove_chimera <- function(seqtab) {
  t(removeBimeraDenovo(t(seqtab), method="consensus", multithread=TRUE, verbose=TRUE))
}