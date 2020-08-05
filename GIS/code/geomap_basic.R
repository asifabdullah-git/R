#install the osmdata, sf, tidyverse and ggmap package
if(!require("osmdata")) install.packages("osmdata")
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("sf")) install.packages("sf")
if(!require("ggmap")) install.packages("ggmap")

#load packages
library(tidyverse)
library(osmdata)
library(sf)
library(ggmap)

#the first five features
available_features()

#amenities
head(available_tags("amenity"))

#shops
head(available_tags("shop"))

#supermarket
head(available_tags("supermarket"))

########################################################################################
########################################################################################
#Where are cinemas in Dhaka?

#building the query
q <- getbb("Dhaka") %>%
  opq() %>%
  add_osm_feature("amenity", "cinema")

str(q) #query structure

cinema <- osmdata_sf(q)
cinema


#our background map
mad_map <- get_map(getbb("Dhaka"), maptype = "toner-background")

#final map
ggmap(mad_map)+
  geom_sf(data = cinema$osm_points,
          inherit.aes = FALSE,
          colour = "#238443",
          fill = "#004529",
          alpha = .5,
          size = 4,
          shape = 21)+
  labs(x = "", y = "")

########################################################################################
########################################################################################
#Where can we find supermarkets?
##bounding box for the Dhaka
m <- c(90.37876,23.75931,90.37886,23.75941)

#building the query
q <- m %>% 
  opq (timeout = 25*100) %>%
  add_osm_feature("name", "Shwapno") %>%
  add_osm_feature("shop", "supermarket")

#query
swapno <- osmdata_sf(q)
swapno
#final map
ggplot(swapno$osm_points)+
  geom_sf(colour = "#08519c",
          fill = "#08306b",
          alpha = .5,
          size = 1,
          shape = 21)+
  theme_void()
