#
library(data.table)
library(tidyverse)
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

eqtl <- fread("data/merged_eqtl.txt.gz", select = c("variant_id", "gene_id"))
eqtl <- eqtl %>% mutate(eqtl = paste0(variant_id, ":", gene_id))
eqtl <- eqtl %>% distinct(eqtl, .keep_all = TRUE)
eqtl <- eqtl %>% group_by(variant_id) %>% tally() %>% rename(num_eqtl = n)

var <- var %>% left_join(y = eqtl, by = "variant_id")
var <- var %>% mutate(num_eqtl = replace_na(num_eqtl, 0))
var <- var %>% mutate(prop = (num_eqtl/num_genes)*100)

ggplot(var %>% filter(prop > 0), aes(prop), aes(num_eqtl)) + geom_histogram(binwidth=1, color="black", fill="white") + ggtitle('Distribution of Significant eQTL Proportion within a Variant Window') + labs(x = 'Proportion of Significant eQTL to Genes')
ggsave("figures/fig9.png")
