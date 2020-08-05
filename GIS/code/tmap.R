
#geocode("mannheim") -- This doesn't work. It needs google API key.

geocode_OSM("mannheim")   #free open souece 


library(tmaptools)
library(tmap)

# change to interactive mode
tmap_mode("view")
data("World")

#HPI-happy planet index
tm_shape(World) +
  tm_polygons("HPI")
#economy
tm_shape(World) +
  tm_polygons("economy")

#combine the both features
tm_shape(World) +
  tm_polygons(c("HPI", "economy")) +
  tm_facets(sync = TRUE, ncol = 2)

data("metro")
# sample 5 cities from the metro dataset
five_cities <- metro[sample(length(metro), 5), ]

# obtain geocode locations from their long names
five_cities_geocode <- geocode_OSM(five_cities$name_long, as.sf = TRUE)
five_cities_geocode

# plot metro coordinates in red and geocode coordinates in blue
# zoom in to see the differences
tm_shape(five_cities) +
  tm_dots(col = "blue") +
  tm_shape(five_cities_geocode) +
  tm_dots(col = "red")


##################################################################################################
###################################################################################################
################################################################################################
install.packages("spData")
remotes::install_github("Nowosad/spDataLarge")


library(sf) 
library(raster)
library(spData)        # load geographic data
#library(spDataLarge)   # load larger geographic data

vignette(package = "sf") # see which vignettes are available
vignette("sf1")          # an introduction to the package

names(world)
plot(world)

bangladesh = world[world$name_long == "Bangladesh", ]
plot(st_geometry(bangladesh), expandBB = c(0, 0.1, 0.1, 1), col = "green", lwd = 3)

tmap_mode("plot")
mapview::mapview(bangladesh)
#alternate way
#mapView(bangladesh, col.regions = "grey")

tm_shape(bangladesh) +
  tm_borders() 

map_bd = tm_shape(bangladesh) + tm_polygons()
class(map_bd)

map_bd1 = map_bd +
  tm_shape(bangladesh_elev) + tm_raster(alpha = 0.7)


tm_shape(bangladesh) + tm_polygons(col = "red")

#
tmap_tip()

help(tmap)
#
map <- get_geocode_OSM(center = c(8.4, 49.5), zoom = 6)

map <- get_googlemap(center = c(8.4, 49.5), zoom = 6)
