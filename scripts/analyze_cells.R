# BBBC018 - Cytoskeleton and Cell Morphology
# Karp Chapter 9

# Selected phenotype and image ID
phenotype <- "Actin blebs"
image_id <- "05624"

# Enter Fiji measurements
d <- data.frame(
  Label = c(
    "05624-actin.DIB:0119-0062",
    "05624-actin.DIB:0092-0292",
    "05624-actin.DIB:0397-0310",
    "05624-actin.DIB:0391-0342",
    "05624-actin.DIB:0359-0345"
  ),
  Area = c(216, 373, 307, 220, 199),
  Mean = c(452.009, 568.389, 553.046, 499.650, 470.754),
  Circ = c(0.324, 0.445, 0.255, 0.254, 0.346),
  AR = c(4.012, 1.879, 4.436, 7.063, 3.747),
  Round = c(0.249, 0.532, 0.225, 0.142, 0.267),
  Solidity = c(0.618, 0.781, 0.573, 0.700, 0.668)
)

# Check measurements
if (nrow(d) != 5) {
  stop("Exactly five measured cells are required.")
}

d$Cell <- paste0("Cell ", seq_len(nrow(d)))

# Create output folders
dir.create("results", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# Save numerical summary
s <- data.frame(
  phenotype = phenotype,
  image_id = image_id,
  cells_measured = nrow(d),
  mean_area_px2 = mean(d$Area),
  mean_circularity = mean(d$Circ),
  mean_aspect_ratio = mean(d$AR),
  mean_actin_signal = mean(d$Mean)
)

write.csv(
  s,
  "results/cell_summary.csv",
  row.names = FALSE
)

print(s)

# Figure 1: Cell area versus circularity
png("figures/area_vs_circularity.png",
    width = 900, height = 650)

plot(
  d$Area, d$Circ,
  pch = 19,
  col = "steelblue",
  xlab = "Cell area (pixels squared)",
  ylab = "Circularity (0 to 1)",
  main = paste(phenotype, "-", image_id)
)

text(
  d$Area, d$Circ,
  labels = d$Cell,
  pos = 3,
  cex = 0.75
)

dev.off()

# Figure 2: Mean actin fluorescence
png("figures/actin_intensity.png",
    width = 900, height = 650)

barplot(
  d$Mean,
  names.arg = d$Cell,
  col = "steelblue",
  ylab = "Mean actin fluorescence (arbitrary units)",
  main = paste("Actin signal -", image_id)
)

dev.off()

# Analysis completed
cat("\nAnalysis completed successfully!\n")