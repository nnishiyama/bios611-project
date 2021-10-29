# R script to quantify likelihood of a variant forming an eQTL based on gene density
# will inherently also be dependent on local allele frequencies
library(tidyverse)
library(ggplot2)

data <- read_tsv('working_data/merged_egenes.txt')
data <- data %>% select(variant_id,chr,variant_pos,gene_id,gene_chr,gene_start,qval)
eqtl <- data %>% select(variant_id,gene_id,qval) %>% unite('eqtl',variant_id,gene_id, sep=':')
eqtl <- eqtl %>% distinct(eqtl, .keep_all = TRUE)
var <- data %>% select(variant_id,chr,variant_pos,qval) #%>% unite('var_pos',chr:variant_pos)
var <- var %>% distinct(variant_id, .keep_all = TRUE)
genes <- data %>% select(gene_id,gene_chr,gene_start) #%>% unite('gene_pos',gene_chr:gene_start)
genes <- genes %>% distinct(gene_id, .keep_all = TRUE)

var <- var %>% mutate(win_start =  variant_pos-1e6)
var <- var %>% mutate(win_end = variant_pos+1e6)

#################### work in progress

#var <- var %>% mutate(num_genes = do(genes %>% filter(gene_chr == chr) %>% count() %>% as.character()))

# define_window <- function(x){
#   win <- c(x-1e6, x+1e6)
#   win
# }

# get_chr <- function(x){
#   chr <- x
#   chr
# }
# 
# get_genes <- function(x){
#   cols <- c('chr','gene_start','win_start','win_end')
#   tmp <- genes <- filter(gene_chr == chr)
#   
# }

# genes %>% filter(gene_chr == "chr1") %>% filter(between(gene_start, w[1],w[2])) %>% count() %>% as.character()
# 
# cvars <- c('chr','gene_start','win_start','win_end')
# genes %>% filter(gene_chr == .data[[cvars[[1]]]]) %>% filter(between(gene_start,))
