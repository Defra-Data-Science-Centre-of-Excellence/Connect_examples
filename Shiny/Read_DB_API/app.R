#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
# Need to set DATABRICKS_HOST and DATABRICKS_TOKEN env variables
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

print(penguins)
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
      plotOutput("distPlot")
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
}

# Run the application 
shinyApp(ui = ui, server = server)