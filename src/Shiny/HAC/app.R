## app.R ##
library(shinydashboard)



head_dropdownMenu <- dropdownMenu(type = "messages",
             messageItem(
               from = "Example",
               message = "HAC Tuning."
             )
)
             

dashboardSidebar_obj <-  dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", tabName = "widgets", icon = icon("th")
             , badgeLabel = 'SUS', badgeColor = 'red')
  )
)



dashboardBody_Obj <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "dashboard",
            fluidRow(
              box(
                title='Graph K-core Layout',
                width =4,
                plotOutput("plot_igraph", height = 250)
              ),
              box(
                title='聚类样本大小分布情况',width =4,
                plotOutput("plot_size", height = 250)
                ),
              box(
                title='聚类内识别数量分布情况',width =4,
                plotOutput("plot_density", height = 250)
              ),
              box(
                #title = "HAC调整等级", 
                status = "warning", solidHeader = TRUE,
                width =12,
                sliderInput("slider", "聚类层级", 1, 100, 20),
                plotOutput("plot_hc", height = 500)
              )
            )
    ),
    tabItem(tabName = "widgets",
            h2("On-going")
    )
  )
)

dashboardHeader_Obj <- dashboardHeader(title = "HAC Example", head_dropdownMenu)


ui <- dashboardPage(
  dashboardHeader_Obj,
  ## Sidebar content
  dashboardSidebar_obj
  ,
  ## Body content
  dashboardBody_Obj
  )


server <- function(input, output) {
  require(data.table)
  require(RColorBrewer)
  require(igraph)
  require(ggdendro)
  library(ggplot2)
  library(dendextend)
  library("ape")
  
  set.seed(123)
  
  CorenessLayout <- function(g) {
    coreness <- graph.coreness(g);
    xy <- array(NA, dim=c(length(coreness), 2));
    
    shells <- sort(unique(coreness));
    for(shell in shells) {
      v <- 1 - ((shell-1) / max(shells));
      nodes_in_shell <- sum(coreness==shell);
      angles <- seq(0,360,(360/nodes_in_shell));
      angles <- angles[-length(angles)]; # remove last element
      xy[coreness==shell, 1] <- sin(angles) * v;
      xy[coreness==shell, 2] <- cos(angles) * v;
    }
    return(xy);
  }
  
  actor     <- sample(1:4, 10, replace=TRUE)
  receiver  <- sample(3:43, 10, replace=TRUE)
  graph <- erdos.renyi.game(200, 0.05, type=c("gnp", "gnm"),
                            directed = FALSE, loops = FALSE)
  coreness_inx = graph.coreness(graph)
  colbar = brewer.pal(max(coreness_inx), "Blues")
  # diverge_hcl(max(coreness_inx),h=c(246, 40), c=96)
  # K-Core Layout

  hc = cluster_fast_greedy(graph)
  dend = as.dendrogram(hc)
  # mimic HAC
  dend_data = dendro_data(dend, type = "rectangle") 
  #db = data.table(v = dend_data$labels[,1], cl =  dend_data$labels[,3])
  
  v = V(graph)
  V(graph)$is_black = rchisq(length(v), df = 2)/10
  
  
  output$plot_hc <- renderPlot({
    
    nodePar <- list(lab.cex = 0.6, pch = c(NA, 19),
                    cex = 0.7, col = "cornflowerblue")
    
    plot(dend,  xlab = "Height",
         nodePar = nodePar, horiz = TRUE, main = '')
  
  }
  )
  
  output$plot_igraph <- renderPlot({
      
    plot(  graph
         , layout=CorenessLayout(graph)
         , vertex.color=colbar[coreness_inx], vertex.size=2, vertex.label.color=colbar[coreness_inx]
         , edged.color = rgb(0.1,0.1,0.1,0.1)
         )
  }
  )

  output$plot_density <- renderPlot({
    cl = cutree(dend, min(length(V(graph)$is_black), as.double(input$slider)) )
    db = data.table(v, cl, rk = V(graph)$is_black)
    db2 = db[,.(size = length(v), risk = mean(rk)), by = cl]
    p = ggplot(db2, aes(x=risk)) + 
      geom_histogram(aes(y=..density..), colour="black", fill="white")+
      geom_density(alpha=.7, fill="firebrick3") + 
      geom_vline(aes(xintercept=mean(risk)), color="cornflowerblue", linetype="dashed", size=2)+theme_minimal()
    print(p)
  }
  )

  output$plot_size <- renderPlot({
    cl = cutree(dend, min(length(V(graph)$is_black), as.double(input$slider)) )
    db = data.table(v, cl, rk = V(graph)$is_black)
    db2 = db[,.(size = length(v), risk = mean(rk)), by = cl]
    p = ggplot(db2, aes(x=size)) + 
      geom_histogram(aes(y=..density..), colour="black", fill="white")+
      geom_density(alpha=.7, fill="firebrick3") + 
      geom_vline(aes(xintercept=mean(size)), color="cornflowerblue", linetype="dashed", size=2)+theme_minimal()
    print(p)
  }
  )
}


shinyApp(ui, server)
