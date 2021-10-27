# R script to plot number of eQTLs per tissue
library(tidyverse)
library(ggplot2)
library(shiny)

data <- read_tsv("shiny/merged_egenes.txt")
data <- data %>% select(gene_name, slope, tissue)
data <- data %>% arrange(desc(abs(slope)))
genes <- unique(data$gene_name)
genes <- genes[1:30]
genes <- as.list(sort(genes))

ui <- fluidPage(
  titlePanel("GTEx eQTLs"),
  sidebarLayout(
    sidebarPanel(
      selectInput("gene", 
                  label = "Choose a gene to display",
                  choices = genes,
                  selected = "WASH7P"
      ),
      submitButton("Submit")
    ),
    mainPanel(
      plotOutput(outputId = "barplot")
    )
  )
)

server <- function(input, output) {
  out <- reactive({
    gene <- input$gene
    tmp <- data %>% filter(gene_name == gene)
    tmp
  })
  output$barplot <- renderPlot({
    # below line is not working properly
    #title <- paste(gene, "eQTLs by tissue", sep = " ")
    title <- "eQTL effect size by tissue"
    ggplot(out(), aes(tissue,slope,fill = tissue))+ geom_bar(stat = "identity")+ theme(plot.title = element_text(hjust = 0.5),legend.position="none", axis.text.x = element_text(angle = 90))+ ylab("eQTL effect size")+ ggtitle(title)
  })
}

shinyApp(ui=ui,server=server,options=list(port=8080, host="0.0.0.0"))