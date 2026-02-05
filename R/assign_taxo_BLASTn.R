assign_taxo <-function(asv_metadata, taxo_db_path, perc_ident = 98){
  # Loading the BLAST db created from the in silico PCR
  db <- rBLAST::blast(db = taxo_db_path)
  seq <- Biostrings::DNAStringSet(asv_metadata$sequence)
  names(seq) <- asv_metadata$ASV_ID
  
  # Assign the taxonomy
  pred <- predict(db, seq,
                  BLAST_args = paste("-perc_identity", perc_ident))
  pred$sseqid <- gsub("_.*", "", pred$sseqid)
  
  # Only get the best match
  res <- split(pred, pred$qseqid) |>
    lapply(function(x) {
      tmp <- sum(x$pident == max(x$pident) & x$evalue == min(x$evalue)) > 1
      cbind(x[1,], "multiple_matches"=tmp)
    })
  res <- do.call(rbind, res)
  
  # Add the info to the taxonomy table
  asv_metadata <- cbind(asv_metadata[,!names(asv_metadata) %in% c("species")], 
                        res[match(asv_metadata$ASV_ID, rownames(res)),-1])
  rownames(asv_metadata) <- NULL
  return(asv_metadata)
}