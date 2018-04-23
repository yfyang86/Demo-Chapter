library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("质量控制"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("WarningLine",
                     "Warning line (X100):",
                     min = 1,
                     max = 20,
                     value = 10)
      ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   ),
   
   sidebarLayout(
     sidebarPanel(
       sliderInput("WarningLine2",
                   "MAD 阈值:",
                   min = 2,
                   max = 4,
                   value = 3,step = .25)
     ),
     
     # Show a plot of the generated distribution
     mainPanel(
       plotOutput("distPlot2")
     )
   )
   ,
   checkboxInput("checkbox",  label = "QI算法:GGPLOT2(口径较大)", value = FALSE),
   checkboxInput("checkbox2", label = "MAD算法(严格检验)", value = FALSE),
   hr(),
   fluidRow(column(2, "输出")),
   fluidRow(column(10, verbatimTextOutput("value")))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  DoubleMAD <- function(x, zero.mad.action="warn"){
    # The zero.mad.action determines the action in the event of an MAD of zero.
    # Possible values: "stop", "warn", "na" and "warn and na".
    x         <- x[!is.na(x)]
    m         <- median(x)
    abs.dev   <- abs(x - m)
    left.mad  <- median(abs.dev[x<=m])
    right.mad <- median(abs.dev[x>=m])
    if (left.mad == 0 || right.mad == 0){
      if (zero.mad.action == "stop") stop("MAD is 0")
      if (zero.mad.action %in% c("warn", "warn and na")) warning("MAD is 0")
      if (zero.mad.action %in% c(  "na", "warn and na")){
        if (left.mad  == 0) left.mad  <- NA
        if (right.mad == 0) right.mad <- NA
      }
    }
    return(c(left.mad, right.mad))
  }
  
  DoubleMADsFromMedian <- function(x, zero.mad.action="warn"){
    # The zero.mad.action determines the action in the event of an MAD of zero.
    # Possible values: "stop", "warn", "na" and "warn and na".
    two.sided.mad <- DoubleMAD(x, zero.mad.action)
    m <- median(x, na.rm=TRUE)
    x.mad <- rep(two.sided.mad[1], length(x))
    x.mad[x > m] <- two.sided.mad[2]
    mad.distance <- abs(x - m) / x.mad
    mad.distance[x==m] <- 0
    return(mad.distance)
  }
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    library(qicharts2)
    library(ggthemes)
    library(ggplot2)
    dummyx <- 10*(rnorm(16,mean = 100,sd = 5)+(1:16)/2)
    ggen =  FALSE
    
    ggen = input$checkbox
    mad  = input$checkbox2
    
    if (ggen){
      x = qicharts2::qic(dummyx, chart='i') + 
        geom_hline(yintercept=100*input$WarningLine, linetype="dashed", color = rgb(0.8,.1,.1,.2), linewidth=4) + 
        ggtitle('QIC质量控制') + 
        theme_hc(bgcolor = "darkunica") 
    }else{
      
      x = qicharts::qic(dummyx, chart='i', main = 'QIC质量控制', cex=1.5, runs.test=T)  ## or mr
      abline(h=100*input$WarningLine, lwd=4,lty=2,col=rgb(0.8,.1,.1,.2))
      output$value <- renderPrint({x})
      
    }
    
    print(x)
  })
  
  
   output$distPlot2 <- renderPlot({
      # generate bins based on input$bins from ui.R
     library(qicharts2)
     library(ggthemes)
     library(ggplot2)
     dummyx <- 10*(rnorm(16,mean = 100,sd = 5)+(1:16)/2)
     ggen =  FALSE
     
     ggen = input$checkbox
     mad  = input$checkbox2
     
       x = qicharts::qic(dummyx, chart='i', main = 'MAD+QIC质量控制', cex=1.5, runs.test=T)  ## or mr
       grid(lty=2,col=rgb(.4,.4,.4,.4))
       abline(h=100*input$WarningLine, lwd=4,lty=2,col=rgb(0.8,.1,.1,.2))
       output$value <- renderPrint({x})
       
     print(x)
     

       x = DoubleMADsFromMedian(dummyx)
       output$value <- renderPrint({data.frame(location=which(x>input$WarningLine2),value=dummyx[x>input$WarningLine2])})
       if( (!ggen) & sum(x>input$WarningLine2)>0)
       points(x=which(x>input$WarningLine2), y = dummyx[x>input$WarningLine2], col=rgb(0.8,.1,.1,.8), cex=4, pch='x')
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

