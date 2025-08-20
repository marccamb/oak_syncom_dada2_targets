plot_read_counts <- function(counts_demultiplex) {
  tmp <- counts_demultiplex[order(counts_demultiplex$nb_read_pairs),]
  tmp$group <- ifelse(grepl("unused", tmp$sample_ID), "unused_tags", "sample")
  tmp$group <- ifelse(grepl("tn|neg", tmp$sample_ID), "neg_control", tmp$group)
  
  
  p <- ggplot(tmp, aes(x = seq_along(nb_read_pairs),
                       y = nb_read_pairs)) +
    geom_point(aes(color = group)) +
    geom_hline(yintercept = 1000, linetype = "dashed", color="red") +
    scale_color_manual(values = c("unused_tags" = "gray",
                                  "neg_control" = "red",
                                  "sample" = "blue")) +
    labs(title = "Nb reads per sample",
                  x = "Samples (ordered by read count)",
                  y = "Read pairs") +
    theme_minimal(base_size = 14) +
    theme(legend.title = element_blank())
  
  return(p)
}
