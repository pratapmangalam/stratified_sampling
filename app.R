library(shiny)

ui <- fluidPage(
  titlePanel("Sampling-2: Stratified Sampling for Population Mean"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("H", "Number of Strata", 4, min = 1),
      
      textInput("Nh", "Stratum sizes (comma separated)",
                "120,100,80,60"),
      
      textInput("Sh2", "Stratum variances (comma separated)",
                "25,16,36,20"),
      
      textInput("Ch", "Cost per unit (comma separated)",
                "50,40,60,55"),
      
      textInput("th", "Time per unit (comma separated)",
                "0.5,0.4,0.6,0.5"),
      
      numericInput("d", "Allowable Error (d)", 2),
      numericInput("b", "Allowable Bias (b)", 0.3),
      numericInput("z", "Z value", 1.96),
      
      selectInput("alloc",
                  "Allocation Method",
                  choices = c("Proportional",
                              "Neyman",
                              "Optimised")),
      
      actionButton("run", "Run Stratified Design")
    ),
    
    mainPanel(
      h4("Required Sample Size"),
      verbatimTextOutput("n"),
      
      h4("Stratum-wise Allocation"),
      tableOutput("allocation"),
      
      h4("Design of Experiment (Stratified Sampling)"),
      plotOutput("designPlot", height = "400px")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$run, {
    
    Nh <- as.numeric(strsplit(input$Nh, ",")[[1]])
    Sh2 <- as.numeric(strsplit(input$Sh2, ",")[[1]])
    Ch <- as.numeric(strsplit(input$Ch, ",")[[1]])
    th <- as.numeric(strsplit(input$th, ",")[[1]])
    
    N <- sum(Nh)
    Wh <- Nh / N
    
    # Sample size for population mean
    n <- ceiling(
      (input$z^2 * sum(Wh^2 * Sh2)) /
        (input$d^2 - input$b^2)
    )
    
    Sh <- sqrt(Sh2)
    
    # Allocation methods
    if (input$alloc == "Proportional") {
      nh <- round(n * Wh)
    }
    
    if (input$alloc == "Neyman") {
      nh <- round(n * (Nh * Sh) / sum(Nh * Sh))
    }
    
    if (input$alloc == "Optimised") {
      weight <- (Nh * Sh) / sqrt(Ch + th)
      nh <- round(n * weight / sum(weight))
    }
    
    # Fix rounding
    nh[1] <- n - sum(nh[-1])
    
    output$n <- renderText(n)
    
    output$allocation <- renderTable({
      data.frame(
        Stratum = 1:length(Nh),
        Population = Nh,
        Sample_Size = nh,
        Variance = Sh2,
        Cost = Ch,
        Time = th
      )
    })
    
    output$designPlot <- renderPlot({
      par(mfrow = c(2, 2))
      
      for (h in 1:length(Nh)) {
        plot(1:Nh[h], rep(1, Nh[h]),
             pch = 16, col = "grey",
             main = paste("Stratum", h),
             xlab = "Unit Index",
             ylab = "",
             yaxt = "n")
        
        points(sample(1:Nh[h], nh[h]),
               rep(1, nh[h]),
               pch = 16, col = "blue", cex = 1.3)
        
        legend("topright",
               legend = c("Population", "Sample"),
               col = c("grey", "blue"),
               pch = 16)
      }
    })
  })
}

shinyApp(ui = ui, server = server)
