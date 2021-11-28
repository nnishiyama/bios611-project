# R script to quantify likelihood of a variant forming an eQTL based on gene density
library(tidyverse)
library(data.table)
library(ggplot2)

data <- read_tsv('data/merged_egenes.txt')
data <- data %>% select(variant_id,chr,variant_pos,gene_id,gene_chr,gene_start,qval)

var <- data %>% select(variant_id,chr,variant_pos,qval)
var <- var %>% distinct(variant_id, .keep_all = TRUE)
var <- var %>% mutate(win_start =  variant_pos-1e6)
var <- var %>% mutate(win_end = variant_pos+1e6)
var$win_start <- if_else(var$win_start < 0, 0, var$win_start)

genes <- data %>% select(gene_id,gene_chr,gene_start)
genes <- genes %>% distinct(gene_id, .keep_all = TRUE)
genes <- genes %>% mutate(gene_end = gene_start)

setDT(genes)
setDT(var)
setkey(genes, gene_chr, gene_start, gene_end)
overlap <- foverlaps(var, genes, by.x = c("chr","win_start","win_end"), type="any")
overlap <- overlap %>% group_by(variant_id) %>% tally() %>% rename(num_genes = n)

var <- var %>% left_join(y = overlap, by = "variant_id")

ggplot(var, aes(num_genes)) + geom_histogram(binwidth=1, color="black", fill="white") + geom_vline(aes(xintercept = median(num_genes)), color="red", linetype="dashed") + ggtitle('Gene Density Based on Variant Window') + labs(x = 'Number of Genes within a Variant Window')
ggsave("figures/fig6.png")