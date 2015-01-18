# ui.R
#
# Electronic implementation of the WHO 2006 Growth Standard, for infants aged 0 - 24 months
#
# - Joseph Chou
# - January 17, 2015
#

library(shiny)

shinyUI(fluidPage(
    titlePanel( textOutput("title") ),
    sidebarLayout(
        sidebarPanel(
            selectInput("measure", label = "Measure", choices = list("Weight" = "Wt", "Head circumference" = "HC", "Length" = "Len"), selected = "Wt"),
            selectInput("gender", label = "Gender", choices = list("Male" = "M", "Female" = "F"), selected = "M"),
            textInput("percentiles", label = "Percentiles", value = "3, 10, 50, 90, 97"),
            br(),
            hr(),
            br(),
            sliderInput("xlimits", "Age (X-axis) display range:", min = 0, max = 24, value = c(0,24)),
            br(),
            sliderInput("ylimits", "Measure (Y-axis) display range:", min = 0, max = 100, value = c(0,100), step = 1),
            hr(),
            p("Application developed by Joseph Chou")
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Plot",
                    plotOutput("growthchart"),
                    hr(),
                    p("Instructions for use"),
                    tags$ul(
                        tags$li("select growth metric of interest: weight, head circumference, or length"),
                        tags$li("select gender"),
                        tags$li("enter a comma separated list of growth percentiles"),
                        tags$li("adjust sliders to select the portion of the plot to display") )
                    ),
                tabPanel("More information",
                     p("In 2006, the World Health Organization (WHO) released an international growth standard which describes
                      the growth of children living in environments believed to support optimal growth.",
                       a("Per the CDC", href="http://www.cdc.gov/growthcharts/who_charts.htm"),
                       ", WHO Growth Standards are recommended for use in the U.S. for infants and children 0 to 2 years of age."),
                     p("While PDF versions of the charts are available at the link above, the purpose of this Shiny application
                      is to generate an electronic version of the WHO growth charts that can be customized on-the-fly. For example:"),
                     tags$ul(
                         tags$li("select gender"),
                         tags$li("select growth metric (weight, head circumference, length)"),
                         tags$li("display a custom set of percentile curves"),
                         tags$li("zoom into desired portions of the chart") ),
                     p("Future versions of this application could add:"),
                     tags$ul(
                        tags$li("import and plotting of patient data"),
                        tags$li("calculation and display of patient measurement percentiles and Z-scores"),
                        tags$li("inclusion of other growth charts")
                    ),
                    p("Known bugs"),
                    tags$ul(
                        tags$li("changing the selected Measure sometimes does not trigger reactive readjustment of the display area")
                    )
                )
            )
        )
    )
))