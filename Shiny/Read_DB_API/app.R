#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
# Need to set DATABRICKS_HOST and DATABRICKS_TOKEN env variables
# Sys.setenv(DATABRICKS_HOST = "https://adb-2353967604677522.2.azuredatabricks.net/", DATABRICKS_TOKEN = "<token>")
# 9cc49d1f-2d62-46f4-b049-8b074a76d018?o=2353967604677522
# These also need to be set on the server.


library(shiny)
library(brickster)


# read a volume, change the path
file <- db_volume_read(
  '/Volumes/prd_dash_lab/dash_data_science_unrestricted/shared_external_volume/penguins.csv',
  tempfile(),
  perform_request = TRUE)

penguins <- read.csv(file)
x    <- penguins$body_mass_g
print(x)

gentoo <- subset(penguins, species == "Gentoo")
print(gentoo)

gentoo <- subset(penguins, species == "Gentoo")

write.csv(gentoo,"gentoo.csv", row.names = FALSE)

db_volume_write(
  '/Volumes/prd_dash_lab/dash_data_science_unrestricted/shared_external_volume/gentoo.csv',
  'gentoo.csv',
  overwrite = TRUE,
  perform_request = TRUE
)

print(penguins)

# Get table form uC

UC_table <- db_sql_query(
  warehouse_id = "09d64966392a2bda",
  statement = "select * from prd_dash_lab.dash_data_science_unrestricted.planning_applications"
)

#print(UC_table)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Palmer Penguins Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      dataTableOutput('table')
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- penguins$body_mass_g
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'body_mass_g',
         main = 'Histogram of penguin body mass')
  })

  output$table <- renderDataTable(UC_table)
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
