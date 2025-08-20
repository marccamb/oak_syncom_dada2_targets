denoise <- function(filt_paths) {
  filtFs <- filt_paths[["filtFs"]]
  filtRs <- filt_paths[["filtRs"]]
 
  errF <- learnErrors(filtFs, multithread=FALSE)
  errR <- learnErrors(filtRs, multithread=FALSE)
  
  dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
  dadaRs <- dada(filtRs, err=errR, multithread=TRUE)
  return(list("dadaFs"=dadaFs, "dadaRs"=dadaRs))
}