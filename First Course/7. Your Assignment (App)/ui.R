library(shinythemes)
library(shinydashboard)

aa <- iris
aa_columns <- c("Sepal.Length","Sepal.Width","Petal.Length","Petal.Width")
xx_species <- c("setosa","versicolor","virginica")

dashboardPage( skin = "red",
               dashboardHeader(title = "Shiny Dashboard for DSN",titleWidth = 300),
               dashboardSidebar(
                 sidebarMenu(
                   menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                   menuItem("Table", tabName = "widgets", icon = icon("th"))
                 ),
                 
                 varSelectInput("aa_columns",
                                "Select Variable to Plot With",
                                data = aa[aa_columns],
                                selected = "Petal.Length"),
                 selectInput("xx_species",
                             "Select Species to Plot With",
                             xx_species,
                             selected = "versicolor")
               ),
               dashboardBody(
                 tabItems(
                   tabItem(tabName = "dashboard",
                           fluidRow(
                             # A static infoBox
                             infoBox("Number of Species", 3, icon = icon("tree"), color = "blue"),
                             # Dynamic infoBoxes
                             infoBoxOutput("petal_length"),
                             infoBoxOutput("sepal_length")
                           ),
                           fluidRow(
                             box(plotOutput("plot1")),
                             box(title = "Correlation Plot for Iris Plants",plotOutput("plot2"))
                           ),
                           fluidRow(
                             box(plotOutput("plot3"), width = 12)
                           )
                   ),
                   tabItem(tabName = "widgets",
                           h2("Iris Dataset"),
                           DT::dataTableOutput('table1')
                   )
                 )
               )
)