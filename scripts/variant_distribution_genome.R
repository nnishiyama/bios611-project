# variant density across chromosomes

library(tidyverse)
library(data.table)

data <- fread("data/merged_eqtl.txt.gz", select = c("variant_id"))
data <- data %>% distinct(variant_id, .keep_all = TRUE)
data <- data %>% separate(variant_id, c("chr","pos","ref","alt"))
data <- data %>% group_by(chr) %>% tally()

chrOrder <- c(paste("chr",1:22,sep=""),"chrX")
data$chr <- factor(data$chr, levels=chrOrder)
data <- data[order(data$chr),]

ggplot(data, aes(chr,n)) + geom_bar(stat = "identity") + ggtitle('Variant Distribution Across Chromosomes') + labs(x = 'Chromosome', y = 'Number of eQTL Variants')
ggsave("figures/fig5.png")