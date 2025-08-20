filt_seq_length <- function(seqtab, seuil = c(0,500)) {
  seqtab[nchar(rownames(seqtab)) %in% seq(seuil[1],seuil[2]), ]
}

plot_sequence_length <- function(seqtab) {
  tmp <- data.frame("seq_length" = nchar(rownames(seqtab)),
                    "seq_name" = rownames(seqtab))
  ggplot(tmp, aes(seq_length)) +
    geom_histogram(binwidth = 5, colour = "#008080", fill = "#008080") +
    theme_classic()
}