# Authored by: debac
# The data used in this application can be download at 
# http://www.calvin.edu/~stob/data/singlefamilyhomeprices.csv
#
library(shiny)
library(datasets)
library(stringr)
library(reshape)
library(ggplot2)

# In the following section we will read the data from the file
# We need to cleanup various fields to get the data ready for analysis
# after downloading the dataset there was some basic manipulation done.
# read the data from the file
hp <- read.csv("homeprices.txt")
# remove any "NA" values
hp <- hp[complete.cases(hp),]
# remove any rows where the state value is more than 2 characters
hp <- hp[str_length(hp$State)==2,]
# Now melt the data.frame to convert the three year columns to rows
hp1 <- melt(hp, id=c("id","City","State"), measured=c("X2004","X2005","X2006"))
# Now substitute the "X" from the year columns
hp1$Year <- gsub("X","", hp1$variable)
# Only select the columns that are necessary for analysis
hp2 <- hp1[,c("City","State","value","Year")]
hp2$Year <- as.factor(hp2$Year)

# Define server logic required to plot the price trend in different States
shinyServer(function(input, output) {

  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and other calculations
  formulaText <- reactive({
    paste("State Selected : ", input$variable)
  })
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  # Now only getting the data for the input state
  hp_state <- reactive({hp2[hp2$State ==input$variable, ]})
  # Aggregating to calculate the average price for each year in that state
  hp_state_agg1 <- reactive({setNames(aggregate(hp_state()[3:3], by=list(hp_state()$Year), mean),c("Year","Mean Home Value in thousands"))})
  # Now calling output for printing this Data Table
  output$hp_state_agg <- renderDataTable({hp_state_agg1()})
  # 
  # Creating a function to print the ggplot
   p <- function(data){
	p=ggplot(data,aes(x=Year,y=value,group=City, color=City))+geom_point(stat="identity")+geom_line()+facet_grid(City ~.)
	}

  # Generate a plot of the price trend across few cities in that state

    output$cityPlot <- renderPlot({
	plot=p(hp_state())
	print(plot)
	})
})
