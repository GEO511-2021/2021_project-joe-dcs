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
    leafletProxy("map", data=sliderData()) %>%
      clearMarkers() %>%
      addTiles() %>%
      setView(lng=-74.431642, lat=8.399157, zoom=3) %>%
      addMarkers(lng = ~longitude, lat = ~latitude)
  })
}

shinyApp(ui = ui, server = server)
