library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage(
    title = "Sales Trends Throughout Day by Hour",
    tabPanel("Home",
    # Sidebar with a slider input for number of bins
    sidebarLayout(position = "left",
        sidebarPanel(
            fileInput("file",
                      HTML("Upload a .csv file with the following column names:
                           <br>Name, Quantity, Price, Hour"),
                      accept = ".csv",
                      placeholder = "Using Demo Data"),
            tags$div(id = 'placeholder')

        ),

        # Show a plot of the generated distribution
        mainPanel(
            radioButtons("yaxis", "Choose what to plot on the Y axis:",
                         c("Quantity", "Total Sales")),
            selectInput("seg", "How often should x axis ticks appear?",
                        c("Every hour", "Every 2 hours", "Every 3 hours"), selected = "Every hour"),
            plotOutput("plot")
        )
    )), #End of Home panel
    tabPanel("About",
             includeMarkdown("about.md"))
))
