# R-shiny-for-mRNA-expression-data
visualizes mRNA-seq data interactively.

This is an interactive Shiny app for visualizing mRNA-seq data, specifically designed to work with plate-based data from RNA sequencing experiments. It allows users to upload datasets and visualize gene expression levels using violin plots.

Features:
Interactive Data Upload: Upload multiple datasets (e.g., from different plates and replicates).
Gene Selection: Select genes of interest for visualization (e.g., TSPAN6).
Violin Plot Visualization: Display interactive violin plots of log-transformed expression data using Plotly.
Data Processing: The app performs necessary preprocessing, including log transformation and gene symbol mapping.

Installation

Prerequisites
R: A statistical programming language (download it from CRAN).
RStudio: (Optional but recommended) for easier development and app management (download it from RStudio).
Install Required Libraries
To run the Shiny app, you need to install several R packages. You can install them from CRAN as follows:

install.packages(c("shiny", "data.table", "ggplot2", "tidyr", "gridExtra", "plotly"))
Alternatively, you can use the install.R script in this repository if available.

Usage

1. Clone the Repository
First, clone the repository to your local machine:

git clone https://github.com/Mode1990/R-shiny-for-mRNA-expression-data.git
2. Run the Shiny App
Once the repository is cloned, navigate to the app directory in RStudio or your preferred R environment and run the app using:

shiny::runApp("path_to_your_cloned_repository")
This will start the Shiny app in your web browser.

3. Upload Your Data
Plate Data: Upload .tsv files for each plate and replicate (e.g., Plate1_rep1.tsv, Plate1_rep2.tsv).
Gene Symbols: Upload the .csv file containing gene symbols, with columns like ensembl_gene_id and external_gene_name.
4. Visualize Data
Input a gene name (e.g., TSPAN6) in the text box.
The app will process the data and display interactive violin plots showing log-transformed expression values for the selected gene.
Directory Structure


 
The app expects data in the following format:

Plate Files (e.g., Plate1_rep1.tsv)
gene_id	sample1	sample2	sample3	...
ENSG0001	23.4	12.2	54.1	...
ENSG0002	12.4	24.2	33.1	...
Gene Symbols File (e.g., GeneSymbols.csv)
ensembl_gene_id	external_gene_name
ENSG0001	TSPAN6
ENSG0002	MYC
