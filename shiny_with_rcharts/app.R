library(shiny)
require(recharts)
library(rCharts)

num <- 100
sensor_data <- data.frame(time = Sys.time() - 1000000 * abs(rnorm(num)))
sensor_data <- cbind(sensor_data, var1 = abs(rnorm(num)))
sensor_data <- cbind(sensor_data, var2 = abs(rnorm(num)))
sensor_data <- cbind(sensor_data, var3 = abs(rnorm(num)))
sensor_data <- sensor_data[order(sensor_data$time, decreasing = TRUE),]

server <- function(input, output, session) {

  autoInvalidate_slow <- reactiveTimer(50000, session)
  autoInvalidate_fast <- reactiveTimer(5000, session)

  # output$hist_chart <- renderPlot({
  #   autoInvalidate_slow()
  #   # par(family='STKaiti')
  #   hist(rnorm(1000), breaks = 100, xlab="Time", ylab="Happy", main="")
  # })

  output$pie_rchart <- renderChart({
    autoInvalidate_slow()
    x <- 1 : ceiling(abs(rnorm(1) * 10))
    d <- data.frame(x)
    p2 <- nPlot(~x, data = d, type = 'pieChart')
    p2$addParams(dom = 'pie_rchart', height = 300)
    return(p2)
  })

  # output$hist_rchart <- renderChart({
  #   # autoInvalidate_slow()
  #   h <- hist(rnorm(100), plot=FALSE)
  #   x <- h$mids
  #   y <- h$density
  #   p1 <- xCharts$new()
  #   p1$layer(y ~ x, data = data.frame(x, y))
  #   p1$set(xScale = 'linear', yScale = 'linear', type = 'line-dotted')
  #   p1$addParams(dom = 'hist_rchart', height = 300)
  #   return(p1)
  # })

  output$hist_rchart <- renderChart({
    autoInvalidate_slow()
    h <- hist(rnorm(100), plot=FALSE)
    x <- h$mids
    y <- h$density
    p1 <- nPlot(y ~ x, data = data.frame(x, y), type = 'multiBarChart')
    p1$addParams(dom = 'hist_rchart', height = 300)
    return(p1)
  })

  # output$pie_chart <- renderPlot({
  #   autoInvalidate_slow()
  #   pie(1:abs(rnorm(1) * 10))
  # }, height=400)

  observe({
   # input$goButton
   # intput$varx <- Sys.time()
   d <- list(Sys.time(), input$var1, input$var2, input$var3)
   sensor_data <<- rbind(d, sensor_data)
 })


  output$data_table <- renderDataTable({
    autoInvalidate_fast()
    # d <- list(Sys.time(), input$var1, input$var2, input$var3)
    # sensor_data <<- rbind(d, sensor_data)
    sensor_data
  }, options = list(orderClasses = TRUE, pageLength = 10))

}

ui <- fluidPage(
  titlePanel("数据盘"),

  splitLayout(
    cellWidths = c("25%", "75%"),

    verticalLayout(
      sidebarPanel(
        sliderInput("var1", "var1", min = 0, max = 1, value = 0.4,
          step = 0.01),
        numericInput("var2", "var2", abs(rnorm(1))),
        numericInput("var3", "var3", abs(rnorm(1))),
        submitButton("Submit"),
        width = 12
        )
      ),

    verticalLayout(
      tabsetPanel(
        id = "theTabs",
        tabPanel("直方图", showOutput("hist_rchart", "nvd3")),
        tabPanel("饼图", showOutput("pie_rchart", "nvd3"))
        ),
      dataTableOutput('data_table')
      )

    )

  )

shinyApp(ui = ui, server = server)
