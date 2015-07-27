# Authored by: debac
library(shiny)

# Define UI for Home prices at different states in USA
# The data used in this application can be download at 
# http://www.calvin.edu/~stob/data/singlefamilyhomeprices.csv
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Home prices across USA - 2004, 2005, 2006"),

  # Sidebar with controls to select the state for which the trend needs to analyzed
  # and to specify whether outliers should be included
  # Not all states put in the list
  sidebarPanel(
    selectInput("variable", "State:",
                list("New York" = "NY", 
                     "California" = "CA", 
                     "Texas" = "TX",
                     "Ohio" = "OH",
                     "New Mexico" = "NM",
                     "Wisconsin" = "WI",
                     "Georgia" = "GA",
                     "New Jersey" = "NJ",
                     "Maryland" = "MD",
                     "Louisiana" = "LA",
                     "Alabama" = "AL",
                     "North Dakota" = "ND",
                     "Illinois" = "IL",
                     "Colorado" = "CO",
                     "Connecticut" = "CT",
                     "Florida" = "FL",
                     "South Carolina" = "SC",
                     "Iowa" = "IA",
                     "Pennsylvania" = "PA",
                     "Oregon" = "OR",
                     "Indiana" = "IN",
                     "North Carolina" = "NC",
                     "Utah" = "UT"))

    #checkboxInput("outliers", "Show outliers", FALSE)
  ),

  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    h3(textOutput("caption")),
    dataTableOutput("hp_state_agg"),
    plotOutput("cityPlot")
  )
))
