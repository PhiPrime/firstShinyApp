#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
shinyServer(function(input, output) {

    #Load Data
    dat <- reactive({
        if (is.null(input$file)) {
            fileLoc <- "./data/testData.csv"
        } else {
            fileLoc <- input$file$datapath
        }
        validate(need(grepl("csv$", fileLoc), fileLoc))
        return(read.csv(fileLoc))
        })

    #Get unique names from dat
    itemNames <- reactive({
        dat <- dat()
        names <- unique(dat$Name)
        return(names[order(names)])
    })

    #Select y axis - Quantity or Total Sales

    #Select x axis - Time or Price

#Update UI based on menu items
    # Display toggle buttons for each item
    observeEvent(!is.null(dat()), {
        insertUI(
            selector = '#placeholder',
            ui = tags$div({
                checkboxGroupInput('items',
                                   "Toggle Items to View:",
                                   itemNames()[1:length(itemNames())])

            })#tags
        )#in.UI
    })

    output$plot <- renderPlot({
        if (length(input$items > 0)) {
            dat <- filter(dat(), Name %in% input$items)
            ggplot(dat, aes(x = Time, y = Quantity,
                            col = Name)) +
                geom_path()

        } else {NULL}
    })

})
