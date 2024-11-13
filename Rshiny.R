# Load required libraries
library(shiny)
library(data.table)
library(ggplot2)
library(tidyr)
library(gridExtra)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("mRNA-seq Data Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      # File input for datasets
      fileInput("file1", "Upload Plate 1 Rep 1 File", accept = ".tsv"),
      fileInput("file2", "Upload Plate 1 Rep 2 File", accept = ".tsv"),
      fileInput("file3", "Upload Plate 2 Rep 1 File", accept = ".tsv"),
      fileInput("file4", "Upload Plate 2 Rep 2 File", accept = ".tsv"),
      
      # File input for gene symbols
      fileInput("gene_file", "Upload Gene Symbols File", accept = ".csv"),
      
      # Select gene for visualization
      textInput("gene", "Enter Gene Name (e.g., TSPAN6)", value = "TSPAN6")
    ),
    
    mainPanel(
      # Display plots
      plotlyOutput("violin_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive expressions for reading in files
  dataset1 <- reactive({
    req(input$file1)
    fread(input$file1$datapath)
  })
  
  dataset2 <- reactive({
    req(input$file2)
    fread(input$file2$datapath)
  })
  
  dataset3 <- reactive({
    req(input$file3)
    fread(input$file3$datapath)
  })
  
  dataset4 <- reactive({
    req(input$file4)
    fread(input$file4$datapath)
  })
  
  gene_mapping <- reactive({
    req(input$gene_file)
    fread(input$gene_file$datapath)
  })
  
  # Process data and create plots
  output$violin_plot <- renderPlotly({
    
    req(dataset1(), dataset2(), dataset3(), dataset4(), gene_mapping())
    
    # Data preprocessing: log10 and gene symbol mapping
    preprocess_data <- function(data, gene_mapping) {
      row.names(data) <- data$gene_id
      data$gene_id <- NULL
      data$GeneName <- rownames(data)
      melted_data <- melt(data, id.vars = "GeneName")
      melted_data$log_value <- log10(melted_data$value)
      melted_data$GeneName <- gsub("\\.\\d+$", "", melted_data$GeneName)
      merged_data <- merge(melted_data, gene_mapping, by.x = "GeneName", by.y = "ensembl_gene_id")
      return(merged_data)
    }
    
    p1_genesymbol <- preprocess_data(dataset1(), gene_mapping())
    p2_genesymbol <- preprocess_data(dataset2(), gene_mapping())
    p3_genesymbol <- preprocess_data(dataset3(), gene_mapping())
    p4_genesymbol <- preprocess_data(dataset4(), gene_mapping())
    
    # Subset data for the selected gene
    gene_data1 <- p1_genesymbol[p1_genesymbol$external_gene_name == input$gene, ]
    gene_data2 <- p2_genesymbol[p2_genesymbol$external_gene_name == input$gene, ]
    gene_data3 <- p3_genesymbol[p3_genesymbol$external_gene_name == input$gene, ]
    gene_data4 <- p4_genesymbol[p4_genesymbol$external_gene_name == input$gene, ]
    
    # Create interactive violin plots
    plot1 <- plot_ly(
      data = gene_data1,
      x = ~"Plate1_rep1",
      y = ~log_value,
      type = "violin",
      box = list(visible = TRUE),
      hoverinfo = "text",
      text = ~paste("Gene: ", external_gene_name)
    ) %>%
      layout(
        title = "Plate1_rep1",
        xaxis = list(title = input$gene),
        yaxis = list(title = "Log10 of Expression Values"),
        showlegend = FALSE
      )
    
    plot2 <- plot_ly(
      data = gene_data2,
      x = ~"Plate1_rep2",
      y = ~log_value,
      type = "violin",
      box = list(visible = TRUE),
      hoverinfo = "text",
      text = ~paste("Gene: ", external_gene_name)
    ) %>%
      layout(
        title = "Plate1_rep2",
        xaxis = list(title = input$gene),
        yaxis = list(title = "Log10 of Expression Values"),
        showlegend = FALSE
      )
    
    plot3 <- plot_ly(
      data = gene_data3,
      x = ~"Plate2_rep1",
      y = ~log_value,
      type = "violin",
      box = list(visible = TRUE),
      hoverinfo = "text",
      text = ~paste("Gene: ", external_gene_name)
    ) %>%
      layout(
        title = "Plate2_rep1",
        xaxis = list(title = input$gene),
        yaxis = list(title = "Log10 of Expression Values"),
        showlegend = FALSE
      )
    
    plot4 <- plot_ly(
      data = gene_data4,
      x = ~"Plate2_rep2",
      y = ~log_value,
      type = "violin",
      box = list(visible = TRUE),
      hoverinfo = "text",
      text = ~paste("Gene: ", external_gene_name)
    ) %>%
      layout(
        title = "Plate2_rep2",
        xaxis = list(title = input$gene),
        yaxis = list(title = "Log10 of Expression Values"),
        showlegend = FALSE
      )
    
    # Combine the plots in a subplot
    subplot(plot1, plot2, plot3, plot4, nrows = 1)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
