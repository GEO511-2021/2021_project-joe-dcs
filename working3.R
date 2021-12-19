Carib_extent <- extent(c(xmin=-130,xmax=-17,ymin=-26,ymax=33))
bbox1 <- bbox(Carib_extent)

OM <- occ("Ophiothela mirabilis", from = c('gbif','bison','inat', 'ebird', 'vertnet'), has_coords=TRUE, limit=1000000, geometry=bbox1)
OMdf <- occ2df(OM) %>%
  mutate(simplename="Ophiothela mirabilis")

OMdf$Year <- format(as.Date(OMdf$date, format="%Y/%m/%d"),"%Y")  

OMdf2 <- OMdf %>%
  filter(Year!=1971)