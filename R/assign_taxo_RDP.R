assign_taxo <-function(asv_metadata, taxo_db_path){
  tax <- assignSpecies(asv_metadata$sequence, taxo_db_path, tryRC = TRUE)
  asv_metadata$genus <- tax[, "Genus"]
  asv_metadata$species <- tax[, "Species"]
  return(asv_metadata)
}