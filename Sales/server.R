#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    dat <- reactive({
        if (is.null(input$file)) {
            fileLoc <- "./data/testData.csv"
        } else {
            fileLoc <- input$file$datapath
        }
        validate(need(grepl("csv$", fileLoc), fileLoc))
        return(read.csv(fileLoc))
        })
    output$text <- renderTable({head(dat())})

})
