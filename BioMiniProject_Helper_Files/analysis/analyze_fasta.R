library(ggplot2)

data <- read.csv("output/motif_counts_local.csv")

p <- ggplot(data, aes(x=sequence_index, y=count)) +
  geom_col(fill="steelblue") +
  theme_minimal()

ggsave("output/r_motif_plot.png", p)
