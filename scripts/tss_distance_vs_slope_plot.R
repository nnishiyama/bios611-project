# R script to plot effect sizes vs distance to gene TSS
# so does the distance to the gene TSS affect the effect size of the eQTL?
library(tidyverse)
library(ggplot2)

data <- read_tsv("data/merged_egenes.txt")
data <- data %>% select(tss_distance, slope, qval)
sig <- data %>% filter(qval < 0.05)
ggplot(sig, aes(tss_distance, slope)) + geom_point() + ggtitle('eQTL Effect Size Based on Distance to Gene') + labs(x = 'Distance to Gene TSS', y = 'eQTL effect size')
ggsave("figures/fig3.png")