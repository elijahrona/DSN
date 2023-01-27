library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggcorrplot)
library(DT)

aa <- iris

# Define server logic
shinyServer(function(input, output) {
  
  output$petal_length <- renderInfoBox({
    infoBox(
      "Average Petal Length", round(mean(aa$Petal.Length),2), icon = icon("leaf"),
      color = "red"
    )
  })
  output$sepal_length <- renderInfoBox({
    infoBox(
      "Average Sepal Length", round(mean(aa$Sepal.Length),2), icon = icon("magic"),
      color = "green"
    )
  })
  
  grouped_aa <- aa %>%
    group_by(Species) %>%
    summarize(Sepal.Length = mean(Sepal.Length), Sepal.Width = mean(Sepal.Width),
              Petal.Length = mean(Petal.Length), Petal.Width = mean(Petal.Width))
  
  output$plot1 <- renderPlot({grouped_aa %>%  
    ggplot(aes(x = Species, y = !!input$aa_columns, fill = Species)) + 
    geom_bar(color = 'black', stat = "identity") +
    ggtitle(paste0(input$aa_columns, " of Different Irises")) +
    theme(panel.background = element_rect(fill = "white",
                                          colour = "white",
                                          size = 0.5, linetype = "solid")) +
    guides(fill="none")+
      scale_fill_manual(values=c("#0073b7", "#e74c3c","#00a65a"))})
  
  aa_cor <- cor(aa[,-5], method = "pearson", use='pairwise.complete.obs')
  
  output$plot2 <- renderPlot({
    ggcorrplot(aa_cor, colors = c("#e74c3c", "#0073b7", "#00a65a"),
               outline.color = "black", lab = TRUE)
  })
  
  xx <- cbind(aa[5], stack(aa[1:4]))
  xx <- xx %>% 
    rename(value = values, parameter = ind)
  
  reactive({})
  
  output$plot3 <- renderPlot({
    grouped_xx <- xx %>%
      group_by(Species, parameter) %>%
      summarize(value = mean(value)) %>%
      filter(Species == input$xx_species)
    
      ggplot(data = grouped_xx, aes(x = parameter, y = value, fill = parameter)) + 
      geom_bar(color = 'black', stat = "identity") +
      ggtitle(paste0("Measurements of Sepals and Petals for", input$xx_species, " Irises")) +
      theme(panel.background = element_rect(fill = "white",
                                            colour = "white",
                                            size = 0.5, linetype = "solid")) +
      guides(fill="none")+
        scale_fill_manual(values=c("#0073b7", "#e74c3c","#00a65a","#f39c12"))
  })
  output$table1 <- DT::renderDataTable(aa)
})

