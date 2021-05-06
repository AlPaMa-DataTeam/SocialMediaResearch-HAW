# Germany map test

library(ggplot2)
library(sp)
library(dplyr)
library(plotly)
library(leaflet)
library(tidyverse)
library(sf)
library(raster)

# tutorial link
# https://ryouready.wordpress.com/2009/11/16/infomaps-using-r-visualizing-german-unemployment-rates-by-color-on-a-map/
# https://keithnewman.co.uk/r/maps-in-r-using-gadm.html

# map source
# https://gadm.org/download_country_v3.html


### --- Map test 1 --- ###
# load map data
de_map <- 
  readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_DEU_1_sf.rds")) %>% 
  st_as_sf()

# plot map 1
plot(de_map, col = 'lightgray')
# weird result, 9 maps displayed?

### --- Map test 2 --- ###
# load map data / alternative way to download
de_map2 <- getData("GADM", country="Germany", level=1)
de_map2$randomData <- rnorm(n=nrow(de_map2), 150, 30)

# plot map 2
pal <- colorQuantile("Reds", NULL, n = 5)

polygon_popup <- paste0("<strong>Bundesland: </strong>", de_map2$NAME_1, "<br>",
                        "<strong>Random data test: </strong>", round(de_map2$randomData,2))

map <- 
  leaflet() %>% 
  addProviderTiles(providers$CartoDB.Voyager) %>% 
  setView(lng = 10.4507147, lat = 50.9833118, zoom = 6) %>% 
  addPolygons(data = de_map2, 
              fillColor= ~pal(randomData),
              fillOpacity = 0.4, 
              weight = 2, 
              color = "white",
              popup = polygon_popup)
