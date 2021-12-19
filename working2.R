library(shiny)
library(leaflet)
library(sp)
library(spocc)
library(raster)
library(tidyverse)
library(leaflet.extras2)
library(sf)
library(geojsonsf)

Carib_extent <- extent(c(xmin=-130,xmax=-17,ymin=-26,ymax=33))
bbox1 <- bbox(Carib_extent)

OM <- occ("Ophiothela mirabilis", has_coords=TRUE, limit=1000000, geometry=bbox1)
OMdf <- occ2df(OM) %>%
  mutate(simplename="Ophiothela mirabilis")
OMdf$Year <- format(as.Date(OMdf$date, format="%Y/%m/%d"),"%Y")        


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
      filter(date <= input$Year)
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
