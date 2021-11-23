# plot relationship between tss distance and eQTL significance
library(tidyverse)
library(data.table)

data <- read_tsv("data/merged_egenes.txt")
data <- data %>% mutate(nlog_q = -log10(qval))

ggplot(data, aes(tss_distance, nlog_q)) + geom_point() + geom_vline(xintercept = 0, color = 'red',linetype = 'dashed') + ggtitle('eQTL Significance Based on Distance to Gene') + labs(x = 'Distance to Gene TSS', y = '-log10(adjusted p-value)')
ggsave("figures/fig2.png")
