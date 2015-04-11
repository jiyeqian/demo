library(shiny)
library(ggvis)

shinyServer(function(input, ...) {

input_size <- reactive(input$size)

mtcars %>% 
  ggvis(~disp, ~mpg, size := input_size) %>%
  layer_points() %>%
  bind_shiny("ggvis", "ggvis_ui")

})