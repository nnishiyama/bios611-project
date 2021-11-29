library(rmarkdown)
path <- getwd()
render("scripts/report.Rmd", output_format = "pdf_document", output_dir = path)