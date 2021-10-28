# R script to plot effect sizes vs distance to gene TSS
library(tidyverse)
library(ggplot2)

data <- read_tsv('working_data/merged_egenes.txt')
data <- data %>% select(tss_distance, slope, qval)
sig <- data %>% filter(qval < 0.05)
distr <- sig %>% group_by(tss_distance) %>% tally()
ggplot(distr, aes(tss_distance)) + geom_histogram(color='black', fill='white') + geom_vline(xintercept=0, color = 'red',linetype='dashed') + ggtitle('Distribution of significant eQTLs variants from gene')
# most significant eQTLs are in close proximity to the gene TSS. this is known.
# so does the distance to the gene TSS affect the effect size of the eQTL?
ggplot(sig, aes(tss_distance, slope)) + geom_point() + geom_smooth(method=lm) + ggtitle('eQTL Effect Size Based on Distance to Gene')
