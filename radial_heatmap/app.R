#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Radial Heatmap Generator"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          numericInput("rings",
                        "Number of rings:",
                        min = 1,
                        max = 1000,
                        value = 20),
          numericInput("segments",
                        "Number of segments:",
                        min = 1,
                        max = 1000,
                        value = 12),
          numericInput("skip_inner_rings",
                        "Skip Number of inner rings:",
                        min = 0,
                        max = 1000,
                        value = 2),
          numericInput("width_of_ring",
                        "Width of rings:",
                        min = 0.05,
                        max = 10,
                        value = 0.25,
                        step = 0.05),
          downloadButton("downloadData", "Download")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot", height = 800, width = 800)
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
      build_segment <- function(min,max,increment,inner_radius,outer_radius){
        x <- c()
        y <- c()
        
        for(i in seq(min, max, increment)){
          x1 <- inner_radius * sin(2*pi*(i/360))
          y1 <- inner_radius * cos(2*pi*(i/360))
          x <- c(x,x1)
          y <- c(y,y1)
        }
        
        for(j in seq(max, min, -increment)){
          x2 <- outer_radius * sin(2*pi*(j/360))
          y2 <- outer_radius * cos(2*pi*(j/360))
          x <- c(x,x2)
          y <- c(y,y2)
        }
        
        path <- 1:length(x)
        
        df <- data.frame(x = x,y = y,path = path,stringsAsFactors = F)
        return(df)
      }
      
      
      n_rings <- input$rings
      n_questions <- input$segments
      radius_start <- input$skip_inner_rings
      radius_increase <- input$width_of_ring
      
      inner_radius <- c()
      outer_radius <- c()
      
      for(r in 1:n_rings){
        inner_radius <- c(inner_radius,rep(radius_start + (radius_increase*(r-1)),n_questions))
        outer_radius <- c(outer_radius,rep(radius_start + (radius_increase*(r)),n_questions))
      }
      
      min <- rep(0:(n_questions-1) *(360/n_questions),n_rings)
      max <- rep(1:n_questions *(360/n_questions),n_rings)
      increment <- rep(360/(n_questions*10),n_questions * n_rings)
      
      levels_df <- data.frame(min = min,
                              max = max,
                              increment = increment,
                              inner_radius = inner_radius,
                              outer_radius = outer_radius,
                              stringsAsFactors = F)
      
      
      n <- nrow(levels_df)
      
      sunburst_list = vector("list", length = n)
      
      for(a in 1:nrow(levels_df)){
        
        df <- build_segment(levels_df$min[a],levels_df$max[a],levels_df$increment[a],levels_df$inner_radius[a],levels_df$outer_radius[a])
        df$id <- a
        df$ring <- floor(a / (n_questions+1)) + 1
        df$segment <- a %% n_questions
        sunburst_list[[a]] <- df
      }
      sunburst_df <- do.call(rbind, sunburst_list)
      
      plot(sunburst_df$x,sunburst_df$y,type="n",asp = 1, xlab = 'x', ylab = 'y')
      polygon(sunburst_df$x,sunburst_df$y)

    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("radial_heatmap.csv", sep = "")
      },
      content = function(file) {
        write.csv(sunburst_df, file, row.names = FALSE)
      }
    )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
