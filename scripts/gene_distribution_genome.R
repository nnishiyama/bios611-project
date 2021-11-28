# plot distribution of genes across chromosomes
library(tidyverse)
library(ggplot2)

data <- read_tsv('data/merged_egenes.txt')

genes <- data %>% select(gene_id,gene_chr)
genes <- genes %>% distinct(gene_id, .keep_all = TRUE)
genes <- genes %>% group_by(gene_chr) %>% tally()
chrOrder <- c(paste("chr",1:22,sep=""),"chrX")
genes$gene_chr <- factor(genes$gene_chr, levels=chrOrder)
genes <- genes[order(genes$gene_chr),]

ggplot(genes, aes(gene_chr,n)) + geom_bar(stat = "identity") + ggtitle('Gene Distribution Across Chromosomes') + labs(x = 'Chromosome', y = 'Number of Genes')
ggsave("figures/fig4.png")