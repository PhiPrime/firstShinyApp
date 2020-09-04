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
        dat <- read.csv(fileLoc)
        ## Validation set not functioning as expected, omitted for time being
        # #Check for required columns
        # validate(need(!any(grepl("Name", colnames(dat))),
        #               message = "Name column not found."),
        #          need(!any(grepl("Quantity", colnames(dat))),
        #               message = "Quantity column not found."),
        #          need(!any(grepl("Price", colnames(dat))),
        #               message = "Price column not found."),
        #          need(!any(grepl("Time", colnames(dat))),
        #               message = "Time column not found."),
        # #Check for required format
        #          need(any(!grepl("[0-9]{2}:[0-9]{2}", dat$Time)),
        #               message =
        #            "At least one entry in Time column not formatted as HH:MM."))
        return(dat)
    })


    #Get unique names from dat
    itemNames <- reactive({
        dat <- dat()
        names <- unique(dat$Name)
        return(names[order(names)])
    })



    #Update UI based on menu items
    observeEvent(!is.null(dat()), {
        insertUI(
            selector = '#placeholder',
            ui = tags$div({
                # Display toggle buttons for each item
                checkboxGroupInput('items',
                                   "Toggle Items to View:",
                                   itemNames()[1:length(itemNames())])

            })#tags
        )#in.UI
    })

    #Get labels & number of ticks based on slider
    ticks <- reactive({
        slide <- input$seg

        min <- min(dat()$Hour)
        max <- max(dat()$Hour)


        # "x axis ticks appear?", c("Every hour", "Every 2 hours", "Every 3 hours")
        feq <- ifelse(grepl("2", slide), 2,
                      ifelse(grepl("3", slide), 3,1))
        ticks <- seq(min, max, by = feq)
        if ((max-min) %% feq != 0) {
            ticks[length(ticks)+1] <- max
        }
        breaks <- ticks
        ticks <- as.character(ticks)
        ticks[nchar(ticks)==1] <- paste0("0", ticks[nchar(ticks)==1])
        ticks <- paste0(ticks, ":00")

        return(list(breaks = breaks,
                    labels = ticks))
    })

    output$plot <- renderPlot({
        if (length(input$items > 0)) {
            #Select y axis - Quantity or Total Sales
            y_axis <- input$yaxis
            if(y_axis == "Total Sales") {
                #Add a Total_Sales column
                y_axis <- "Total_Sales"
                dat <- filter(dat(), Name %in% input$items) %>%
                    mutate(Total_Sales = Price * Quantity)
            } else {
                #Filter data by selected items
                dat <- filter(dat(), Name %in% input$items)
            }

            #Generate plot
            ggplot(dat, aes_string(x = "Hour", y = y_axis)) +
                geom_path(aes(col = Name)) +
                scale_x_continuous(breaks = ticks()$breaks,
                                   labels = ticks()$labels)


        } else {NULL}
    })

})
