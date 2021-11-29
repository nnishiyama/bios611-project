# pull top variant
library(tidyverse)
library(data.table)
library(tools)
library(biomaRt)
library(formattable)
library(htmltools)
library(webshot)

d <- read_tsv('data/merged_egenes.txt')
d <- d %>% filter(variant_id == "chr19_21570287_A_C")
length(unique(d$gene_id))
length(unique(d$tissue))
t <- d %>% group_by(gene_id) %>% tally() %>% arrange(desc(n))
# max tissues shared by a gene is 5
d %>% filter(gene_id == "ENSG00000268433.1") %>% dplyr::select(tissue)
# 3/5 tissues are CNS/brain-related
# ENSG00000268433.1 = MTDHP3 metadherin pseudogene 3
d %>% filter(gene_id == "ENSG00000268555.1") %>% select(tissue)
# no obvious tissue grouping
# ENSG00000268555 = novel transcript; lncRNA
d %>% filter(gene_id == "ENSG00000268658.5") %>% select(tissue)
# no obvious tissue grouping
# ENSG00000268658 = lncRNA; LINC00664
d %>% filter(gene_id == "ENSG00000268240.1") %>% select(tissue)
# 2/3 immune tissues
# ENSG00000268240 = novel transcript;lncRNA
d %>% filter(gene_id == "ENSG00000268240.1") %>% select(tissue)

g <- t$gene_id
g <- file_path_sans_ext(g)

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))

b <- getBM(attributes = c("ensembl_gene_id","external_gene_name","gene_biotype","description"),
           filters = "ensembl_gene_id", values = g, mart = mart)
b$ensembl_gene_id <- factor(b$ensembl_gene_id, levels=g)
b <- b[order(b$ensembl_gene_id),] %>% rename(gene_id = ensembl_gene_id)

c <- formattable(as.tibble(b), align=c("l","c","c","c"))

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

export_formattable(c, "figures/table3.png")



###############################################################################
t <- t %>% mutate(gene_id = g)


b <- b %>% left_join(y = t, by = "gene_id")
