# plot distribution of variants forming an eqtl across chromosomes
library(tidyverse)
library(ggplot2)

data <- read_tsv('working_data/merged_egenes.txt')

var <- data %>% select(variant_id,chr,variant_pos,qval)
var <- var %>% distinct(variant_id, .keep_all = TRUE)

v <- var %>% group_by(chr) %>% tally()
chrOrder <- c(paste("chr",1:22,sep=""),"chrX")
v$chr <- factor(v$chr, levels = chrOrder)
v <- v[order(v$chr),]

ggplot(v, aes(chr, n)) + geom_bar(stat="identity")
# add title & make pretty