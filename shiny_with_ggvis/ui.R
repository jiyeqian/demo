library(shiny)
library(ggvis)

shinyUI(fluidPage(

  # Application title
  titlePanel("Hello Shiny!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("size", "Area", 10, 1000, 600)
      ),

    # Show a plot of the generated distribution
    mainPanel(
      uiOutput("ggvis_ui"),
      ggvisOutput("ggvis")
      )
    )
  ))