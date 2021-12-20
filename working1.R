library(sp)
library(spocc)
library(leaflet)
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

OMdf2 <- OMdf %>%
  filter(Year!=1971)


OM_geojson <- df_geojson(df=OMdf,lon="longitude" ,lat="latitude")
OMsf <- geojson_sf(OM_geojson)

OMpoint <- st_cast(OMsf, "POINT")
OMsf$date = as.POSIXct(
  seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))


OMmap <- leaflet(data = OMdf2) %>%
          addTiles() %>%
            addTimeslider(data = OMsf,
                options = timesliderOptions(
                  position = "topright",
                  timeAttribute = "time",
                  range = TRUE)) %>%
          setView(lng=-74.431642, lat=8.399157, zoom=4) %>%
          addMarkers(lng = ~longitude, lat = ~latitude)
OMmap
