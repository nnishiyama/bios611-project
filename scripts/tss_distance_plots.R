# R script to plot distribution of eQTLs based on distance to gene TSS.
library(tidyverse)
library(ggplot2)

data <- read_tsv("data/merged_egenes.txt")
data <- data %>% select(tss_distance, slope, qval)
sig <- data %>% filter(qval < 0.05)
distr <- sig %>% group_by(tss_distance) %>% tally()
ggplot(distr, aes(tss_distance)) + geom_histogram(color = 'black', fill = 'white') + geom_vline(xintercept = 0, color = 'red',linetype = 'dashed') + ggtitle('Distribution of significant eQTL variants from gene') + labs(x = 'Distance to Gene TSS')
ggsave("figures/fig1.png")
