#!/usr/bin/env Rscript

# R-based FASTA Analysis Visualization
# Reads CSV results from Python analysis and creates advanced visualizations

# Load required libraries
library(ggplot2)
library(grid)
library(gridExtra)

# Command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  cat("Usage: Rscript fasta_analysis.R <csv_file> <output_dir> [motif]\n")
  cat("Example: Rscript fasta_analysis.R results/motif_analysis_ATG.csv results ATG\n")
  quit(status = 1)
}

csv_file <- args[1]
output_dir <- args[2]
motif <- if (length(args) >= 3) args[3] else "MOTIF"

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
}

# Read CSV file
tryCatch({
  data <- read.csv(csv_file, stringsAsFactors = FALSE)
  cat("Successfully read CSV file:", csv_file, "\n")
  cat("Rows:", nrow(data), "| Columns:", ncol(data), "\n\n")
}, error = function(e) {
  cat("ERROR: Could not read CSV file:", csv_file, "\n")
  cat("Details:", e$message, "\n")
  quit(status = 1)
})

# Display data summary
cat("Data Summary:\n")
cat("=============\n")
print(data)
cat("\n")

# Summary statistics
cat("Summary Statistics:\n")
cat("===================\n")
cat("Motif:", unique(data$motif), "\n")
cat("Total Sequences:", nrow(data), "\n")
cat("Total Motif Count:", sum(data$count), "\n")
cat("Average Frequency:", round(mean(data$frequency), 4), "\n")
cat("Max Count:", max(data$count), "in sequence:", 
    data$sequence_id[which.max(data$count)], "\n\n")

# ===== Visualization 1: Bar plot with frequency colors =====
p1 <- ggplot(data, aes(x = reorder(sequence_id, count), y = count, 
                        fill = frequency)) +
  geom_col(color = "black", size = 1) +
  scale_fill_gradient(low = "lightblue", high = "darkred", 
                      name = "Frequency") +
  labs(
    title = paste("Motif Count Distribution:", motif),
    x = "Sequence ID",
    y = "Motif Count"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.text.y = element_text(size = 10),
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right"
  )

# Save first visualization
p1_file <- file.path(output_dir, paste0("r_motif_barplot_", motif, ".png"))
ggsave(p1_file, p1, width = 10, height = 6, dpi = 300)
cat("Saved bar plot to:", p1_file, "\n")

# ===== Visualization 2: Frequency distribution with points =====
p2 <- ggplot(data, aes(x = sequence_id, y = frequency)) +
  geom_point(aes(color = count, size = count), alpha = 0.7) +
  geom_line(group = 1, color = "gray50", linetype = "dashed", alpha = 0.5) +
  scale_color_gradient(low = "green", high = "red", name = "Count") +
  scale_size_continuous(name = "Count", range = c(3, 10)) +
  labs(
    title = paste("Motif Frequency Distribution:", motif),
    x = "Sequence ID",
    y = "Frequency"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right"
  )

# Save second visualization
p2_file <- file.path(output_dir, paste0("r_motif_frequency_", motif, ".png"))
ggsave(p2_file, p2, width = 10, height = 6, dpi = 300)
cat("Saved frequency plot to:", p2_file, "\n")

# ===== Visualization 3: Comparative bar + line plot =====
p3 <- ggplot(data, aes(x = reorder(sequence_id, -count))) +
  geom_col(aes(y = count), fill = "steelblue", alpha = 0.7, color = "navy") +
  geom_point(aes(y = count * 10), color = "red", size = 4, shape = 21, 
             fill = "yellow", stroke = 2) +
  geom_line(aes(y = count * 10, group = 1), color = "red", 
            linetype = "dotted", size = 1, alpha = 0.6) +
  scale_y_continuous(
    name = "Count",
    sec.axis = sec_axis(~./10, name = "Count (Scaled)")
  ) +
  labs(
    title = paste("Motif Count Analysis:", motif),
    x = "Sequence ID"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(face = "bold", size = 14),
    axis.title.y.left = element_text(color = "steelblue", size = 11),
    axis.title.y.right = element_text(color = "red", size = 11)
  )

# Save third visualization
p3_file <- file.path(output_dir, paste0("r_motif_combined_", motif, ".png"))
ggsave(p3_file, p3, width = 10, height = 6, dpi = 300)
cat("Saved combined plot to:", p3_file, "\n")

# ===== Visualization 4: Pie chart of contribution =====
pie_data <- data.frame(
  sequence = data$sequence_id,
  count = data$count
)

# Only include non-zero counts for readability
pie_data_nonzero <- pie_data[pie_data$count > 0, ]

if (nrow(pie_data_nonzero) > 0) {
  p4 <- ggplot(pie_data_nonzero, aes(x = "", y = count, fill = sequence)) +
    geom_col(color = "black", size = 1) +
    coord_polar(theta = "y") +
    labs(
      title = paste("Contribution by Sequence:", motif),
      fill = "Sequence"
    ) +
    theme_void() +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      legend.position = "right"
    )
  
  p4_file <- file.path(output_dir, paste0("r_motif_pie_", motif, ".png"))
  ggsave(p4_file, p4, width = 8, height = 6, dpi = 300)
  cat("Saved pie chart to:", p4_file, "\n")
}

# ===== Save summary table as CSV =====
summary_table <- data.frame(
  "Sequence" = data$sequence_id,
  "Length" = data$sequence_length,
  "Count" = data$count,
  "Frequency" = round(data$frequency, 4)
)

table_file <- file.path(output_dir, paste0("r_analysis_table_", motif, ".csv"))
write.csv(summary_table, table_file, row.names = FALSE)
cat("Saved summary table to:", table_file, "\n")

# ===== Generate R summary file =====
summary_file <- file.path(output_dir, paste0("r_analysis_summary_", motif, ".txt"))
sink(summary_file)

cat("R Analysis Summary Report\n")
cat("=========================\n")
cat("Generated:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")
cat("Input CSV:", csv_file, "\n")
cat("Motif:", motif, "\n")
cat("R Version:", as.character(getRversion()), "\n\n")

cat("Data Summary:\n")
cat("- Total Sequences:", nrow(data), "\n")
cat("- Total Motif Count:", sum(data$count), "\n")
cat("- Average Count:", round(mean(data$count), 2), "\n")
cat("- Median Count:", median(data$count), "\n")
cat("- Min Count:", min(data$count), "\n")
cat("- Max Count:", max(data$count), "\n")
cat("- Std Dev:", round(sd(data$count), 2), "\n\n")

cat("Sequence Details:\n")
cat("-----------------\n")
for (i in 1:nrow(data)) {
  cat(sprintf("%2d. %s: count=%3d, freq=%.4f, length=%d\n",
              i, data$sequence_id[i], data$count[i], 
              data$frequency[i], data$sequence_length[i]))
}

cat("\n\nGenerated Visualizations:\n")
cat("- r_motif_barplot_", motif, ".png\n")
cat("- r_motif_frequency_", motif, ".png\n")
cat("- r_motif_combined_", motif, ".png\n")
if (nrow(pie_data_nonzero) > 0) {
  cat("- r_motif_pie_", motif, ".png\n")
}
cat("- r_analysis_table_", motif, ".csv\n")

sink()

cat("\nSaved summary report to:", summary_file, "\n")

cat("\n✓ R Analysis Complete!\n")
cat("All visualizations and reports saved to:", output_dir, "\n")
