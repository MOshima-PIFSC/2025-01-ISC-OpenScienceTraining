library(shiny)
library(bslib)
library(ggplot2)

ui <- page_sidebar(
  title = "Simple Data Explorer",
  sidebar = sidebar(
    # Input controls
    numericInput("n_points", 
                 "Number of points", 
                 value = 100,
                 min = 10,
                 max = 1000),
    
    sliderInput("noise", 
                "Noise level",
                min = 0,
                max = 2,
                value = 1,
                step = 0.1),
    
    selectInput("color", 
                "Point color",
                choices = c("blue", "red", "green", "purple"),
                selected = "blue")
  ),
  
  # Main panel with plot output
  card(
    card_header("Scatter Plot"),
    card_body(
      plotOutput("scatter_plot")
    )
  )
)

server <- function(input, output) {
  # Generate random data based on inputs
  data <- reactive({
    x <- seq(0, 10, length.out = input$n_points)
    y <- sin(x) + rnorm(input$n_points, 0, input$noise)
    data.frame(x = x, y = y)
  })
  
  # Create the scatter plot
  output$scatter_plot <- renderPlot({
    ggplot(data(), aes(x = x, y = y)) +
      geom_point(color = input$color, alpha = 0.6) +
      geom_smooth(method = "loess", se = TRUE) +
      theme_minimal() +
      labs(title = "Sine Wave with Noise",
           x = "X value",
           y = "Y value")
  })
}

shinyApp(ui, server)
