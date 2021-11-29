#
library(tidyverse)
library(data.table)
library(formattable)
library(htmltools)
library(webshot)
library(R.utils)

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
var <- var %>% arrange(desc(num_eqtl))

v <- head(var) %>% select(variant_id,num_genes,num_eqtl,prop)
t <- formattable(v, align=c("l","c","c","c"))

export_formattable <- function(f, file, width = "100%", height = NULL, 
                               background = "white", delay = 0.2)
{
  w <- as.htmlwidget(f, width = width, height = height)
  path <- html_print(w, background = background, viewer = NULL)
  url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
  webshot(url,
          file = file,
          selector = ".formattable_widget",
          delay = delay)
}

export_formattable(t, "figures/table2.png")
