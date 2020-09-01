#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Upload a .csv file",
                      accept = ".csv",
                      placeholder = "Using Demo Data"),
            p("The following column names are required: Name, Quantity, Price, Time"),
            tags$div(id = 'placeholder')

        ),

        # Show a plot of the generated distribution
        mainPanel(
            radioButtons("xaxis", "Choose what to plot on the X axis:",
                         c("Time", "Price")),
            radioButtons("yaxis", "Choose what to plot on the Y axis:",
                         c("Quantity", "Total Sales")),
            plotOutput("plot")
        )
    )
))
