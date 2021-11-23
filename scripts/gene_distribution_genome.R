# plot distribution of genes across chromosomes
library(tidyverse)
library(ggplot2)

data <- read_tsv('working_data/merged_egenes.txt')

genes <- data %>% select(gene_id,gene_chr,gene_start)
genes <- genes %>% distinct(gene_id, .keep_all = TRUE)


g <- genes %>% group_by(gene_chr) %>% tally()
chrOrder <- c(paste("chr",1:22,sep=""),"chrX")
g$gene_chr <- factor(g$gene_chr, levels=chrOrder)
g <- g[order(g$gene_chr),]

ggplot(g,aes(gene_chr,n)) + geom_bar(stat="identity")
# need to add title; make pretty