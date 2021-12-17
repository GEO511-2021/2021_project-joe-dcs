#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(bottom = 30, right = 10,
                  sliderInput("Year", "Year", 1995, 2021, value = 1995, step = 1, sep = "")
    )
)

server <- function(input, output, session) {
    
    sliderData <- reactive({
        OMdf %>%
            filter(Year <= input$Year)
    })
    
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            fitBounds(min(OMdf$longitude), min(OMdf$latitude),
                      max(OMdf$longitude), max(OMdf$latitude))
    })
    
    observe({
        leafletProxy("map", data = sliderData()) %>%
            clearMarkers() %>%
            addTiles() %>%
            addMarkers(lng = ~longitude, lat = ~latitude)
    })
}

shinyApp(ui = ui, server = server)
