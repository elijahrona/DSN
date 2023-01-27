library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(title = "Box 1"), #first box
      
      box(title = "Box 2", #second box
          solidHeader = TRUE)
    ),
    fluidRow(
      box(title = "Box 3", solidHeader = TRUE, #third box
          collapsible = TRUE, status = "warning"), 
    )
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)