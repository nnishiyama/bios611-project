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

eqtl <- data %>% select(variant_id, gene_id, qval)
eqtl <- eqtl %>% mutate(eqtl = paste0(variant_id,':', gene_id)) %>% distinct(eqtl, .keep_all = TRUE)
eqtl <- eqtl %>% filter(qval < 0.05) %>% group_by(variant_id) %>% tally() %>% rename(num_eqtl = n)

var <- var %>% left_join(y = eqtl, by = "variant_id")
var <- var %>% mutate(num_eqtl = replace_na(num_eqtl, 0))
var <- var %>% mutate(prop = (num_eqtl/num_genes)*100)

ggplot(var %>% filter(num_eqtl > 0), aes(num_eqtl)) + geom_histogram(binwidth=1, color="black", fill="white") + ggtitle('eQTL Density for Primary eQTL Variants') + labs(x = 'Number of eQTL per Primary eQTL Variant')
ggsave("figures/fig7.png")
