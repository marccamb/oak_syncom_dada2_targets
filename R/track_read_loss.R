track_read_loss <- function(counts_filts, dada_F, mergers, seqtab_filt, seqtab_filt_nochim, seqtab_filt_nochim_abund) {
  ### Read loss
  getN <- function(x) sum(getUniques(x))
  track <- cbind(
    counts_filts,
    sapply(dada_F, getN), 
    sapply(mergers, getN),
    colSums(seqtab_filt),
    colSums(seqtab_filt_nochim),
    colSums(seqtab_filt_nochim_abund)
  )
  colnames(track) <- c("demultiplexed", "qual_fitered", "denoisedF", "merged", "length_filtered", "nonchim", "ASV_>_1000_reads")
  rownames(track) <- names(mergers)
  return(track)
}

plot_read_loss <- function(read_loss) {
  data <- data.frame(
    x=factor(colnames(read_loss), levels=factor(colnames(read_loss))),
    y=colSums(read_loss)
  )
  
  ggplot(data, aes(x=x, y=y)) +
    geom_segment(aes(x=x, xend=x, y=0, yend=y), color="grey") +
    geom_point( color="orange", size=4) +
    theme_light() +
    theme(
      panel.grid.major.x = element_blank(),
      panel.border = element_blank(),
      axis.ticks.x = element_blank()
    ) +
    xlab("Processing step") +
    ylab("Number of reads")
}