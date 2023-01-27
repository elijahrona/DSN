library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(sidebarMenu( #for tabs
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Tab 2 for DSN", tabName = "dsn", icon = icon("th"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
    fluidRow( #row for KPIS
      # A static infoBox or KPI
      infoBox("Number of Plots", 3, icon = icon("dashboard"), color = "blue"),
      # Dynamic infoBoxes
      infoBoxOutput("petal_length"),
      infoBoxOutput("sepal_length")
    ),
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(title = "Box 1",
          plotOutput("p1")), #first box
      
      box(title = "Box 2", #second box
          solidHeader = TRUE,
          plotOutput("p2"),status = "success"
      )),
    fluidRow(
      box(title = "Box 3", solidHeader = TRUE, #third box
          collapsible = TRUE, status = "warning",
          plotOutput("p3"), width = 12 
      )
    )
  ), #Comma here
  tabItem(tabName = "dsn",
          h2("Anything Can Go In Here"))
)))

server <- function(input, output) {
  library(tidyverse)
  library(ggcorrplot)
  
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
  
  aa <- iris
  output$p1 <- renderPlot({ #Insert every function and data used to make the plot into the server
    
    grouped_aa <- aa %>%
      group_by(Species) %>%
      summarize(Sepal.Length = mean(Sepal.Length), Sepal.Width = mean(Sepal.Width),
                Petal.Length = mean(Petal.Length), Petal.Width = mean(Petal.Width))
    
    grouped_aa %>%  
      ggplot(aes(x = Species, y = Sepal.Width, fill = Species)) + 
      geom_bar(color = 'black', stat = "identity") +
      ggtitle("Sepal Width of Different Irises") +
      theme(panel.background = element_rect(fill = "white",
                                            colour = "white",
                                            size = 0.5, linetype = "solid")) +
      guides(fill="none")
    
  })
  
  output$p2 <- renderPlot({
    aa_cor <- cor(aa[,-5], method = "pearson", use='pairwise.complete.obs')
    ggcorrplot(aa_cor, colors = c("#e74c3c", "#0073b7", "#00a65a"),
               outline.color = "black", lab = TRUE)
  })
  
  output$p3 <- renderPlot({
    aa1 <- txhousing
    
    aa1 <- aa1 %>% #Filter the data
      filter(year == c("2000","2001","2003","2004","2005"), 
             city == c("Abilene","Arlington","Bay Area"))
    
    ggplot(data=aa1, aes(x=year, y=sales, group=city, colour=city)) +
      geom_line(size = 1.0) +
      geom_point() +
      theme(
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        size = 0.5, linetype = "solid")) +
      ggtitle("Line Chart")
  })
  
}

shinyApp(ui, server)