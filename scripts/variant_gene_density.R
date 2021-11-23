# R script to quantify likelihood of a variant forming an eQTL based on gene density
# will inherently also be dependent on local allele frequencies
library(tidyverse)
library(ggplot2)

data <- read_tsv('working_data/merged_egenes.txt')
data <- data %>% select(variant_id,chr,variant_pos,gene_id,gene_chr,gene_start,qval)

eqtl <- data %>% mutate(eqtl = paste0(variant_id,':', gene_id))
#eqtl <- data %>% select(variant_id,gene_id,qval) %>% unite('eqtl',variant_id,gene_id, sep=':')
eqtl <- eqtl %>% distinct(eqtl, .keep_all = TRUE)
e <- eqtl %>% filter(qval <= 0.05) %>% group_by(variant_id) %>% tally()
colnames(e) <- c('variant_id','num_sig_eqtl')

var <- data %>% select(variant_id,chr,variant_pos,qval) #%>% unite('var_pos',chr:variant_pos)
var <- var %>% distinct(variant_id, .keep_all = TRUE)
var <- var %>% mutate(win_start =  variant_pos-1e6)
var <- var %>% mutate(win_end = variant_pos+1e6)

genes <- data %>% select(gene_id,gene_chr,gene_start) #%>% unite('gene_pos',gene_chr:gene_start)
genes <- genes %>% distinct(gene_id, .keep_all = TRUE)



count_genes <- function(x, y, z){
  tmp <- genes %>% filter(gene_chr  == x, between(gene_start, y, z)) %>% nrow()
  tmp
}

var <- var %>% rowwise() %>% mutate(num_gene = count_genes(chr, win_start, win_end))

#################################################################################
test = head(var)
count_genes <- function(x, y, z){
  tmp <- genes %>% filter(gene_chr  == x)
  tmp <- tmp %>% filter(between(gene_start, y, z)) %>% nrow()
  tmp
}
test <- test %>% rowwise() %>% mutate(new = count_genes(chr, win_start, win_end))
test

g <- genes %>% group_by(gene_chr)





g <- genes %>% mutate(gene_end = gene_start)
setkey(setDT(var), chr, win_start, win_end)
setDT(g)
o <- foverlaps(g, var, by.x = c("gene_chr","gene_start","gene_end"))
o <- foverlaps(g, var, by.x = c("gene_chr","gene_start","gene_end"), type = "within")
o <- o %>% group_by(variant_id) %>% tally() %>% drop_na()
j <- var %>% left_join(y = o, by = "variant_id")
sum(is.na(j))

k <- j %>% left_join(y = e, by = "variant_id")
k <- k %>% mutate(prop = (num_sig_eqtl/n)*100)
k <- k %>% arrange(desc(prop))

# in example, x = gene, y = var window
