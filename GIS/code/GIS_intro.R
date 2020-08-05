#https://github.com/jessesadler/intro-to-r

# Load the sp package
library(sp)

# Spatial classes
getClass("Spatial")

# slots for SpatialPoints class
slotNames("SpatialPoints")

# slots for SpatialPointsDataFrame
slotNames("SpatialPointsDataFrame")

# Load the packages
#install.packages('rnaturalearth')
library(tidyverse)
library(sp)
library(sf)
library(rnaturalearth)

#load the data
letters <- read_csv("https://raw.githubusercontent.com/jessesadler/intro-to-r/master/data/correspondence-data-1585.csv")
locations <- read_csv("https://raw.githubusercontent.com/jessesadler/intro-to-r/master/data/locations.csv")

# Letters per source
sources <- letters %>% 
  group_by(source) %>% 
  count() %>% 
  rename(place = source) %>% 
  add_column(type = "source") %>% 
  ungroup()

# Letters per destination
destinations <- letters %>% 
  group_by(destination) %>% 
  count() %>% 
  rename(place = destination) %>% 
  add_column(type = "destination") %>% 
  ungroup()

# Bind the rows of the two data frames
# and change type column to factor
letters_data <- rbind(sources, destinations) %>% 
  mutate(type = as_factor(type))

# Print letters_data
letters_data

# Join letters_data to locations
geo_data <- left_join(letters_data, locations, by = "place")

# Print data with longitude and latitude columns
geo_data

#geo_data <- as.data.frame(geo_data)
#geo_data

# Create data frame of only longitude and latitude values--------------error???#
#install.packages('conflicted')
#library(conflicted)

coords <- dplyr::select(geo_data, lon, lat)

# Create SpatialPoints object with coords and CRS
points_sp <- SpatialPoints(coords = coords,
                           proj4string = CRS("+proj=longlat +datum=WGS84"))

# Print SpatialPoints object
points_sp

# Structure of SpatialPoints object
str(points_sp)

# Create SpatialPointsDataFrame object
points_spdf <- SpatialPointsDataFrame(coords = coords,
                                      data = letters_data,  
                                      proj4string = CRS("+proj=longlat +datum=WGS84"))
# Print out SpatialPointsDataFrame
points_spdf

# Structure of SpatialPointsDataFrame object
str(points_spdf)

# Access the data frame of a SpatialPointsDataFrame
points_spdf@data

# Example of subsetting `points_spdf` to return locations with "n" greater than 10
points_spdf[points_spdf@data$n > 10, ]

library(rnaturalearth)
library(sp)
install.packages("rnaturalearthdata")
# Get coastal and country world maps as Spatial objects
coast_sp <- ne_coastline(scale = "medium")
countries_sp <- ne_countries(scale = "medium")

# Structure of SpatialLinesDataFrame
str(coast_sp, max.level = 2)
#Structure of SpatialPolygonsDataFrame
str(countries_sp, max.level = 2)

# Check CRS of Spatial objects
coast_sp@proj4string

proj4string(countries_sp)

proj4string(points_spdf)

#########################################################################################
#########################################################################################
#Mapping with sp

# Create a new color palette to distinguish source and destination
palette(alpha(c("darkorchid", "darkorange"), 0.7))
# Set margins for bottom, left, top, and right of plot
par(mar = c(1, 1, 3, 1))

# Plot points
plot(points_spdf,
     pch = 20,
     col = points_spdf$type,
     cex = sqrt(points_spdf$n)/2 + 0.25)

# Add a box around the plot
box()
# Add a title
title(main = "Correspondence of Daniel van der Meulen, 1585")


# Pointsize vector for legend
pointsize <- c(1, 50, 100)
par(mar = c(1, 1, 3, 1))

# Plot points
plot(points_spdf,
     pch = 20,
     col = points_spdf$type,
     cex = sqrt(points_spdf$n)/2 + 0.25)
# Plot coastlines background map
plot(coast_sp,
     col = "black",
     add = TRUE)
# Add a box around the plot
box()

# Legend for colors
legend("topright", legend = levels(points_spdf$type),
       pt.cex = 2,
       col = 1:2,
       pch = 15)

# legend for size of points
legend("right", legend = pointsize,
       pt.cex = (sqrt(pointsize)/2 + 0.25),
       col = "black",
       pch = 20,
       title = "Letters")

# Title for the map
title(main = "Correspondence of Daniel van der Meulen, 1585")


# Make bounding box for countries_sp match
# bounding box of points_spdf
countries_sp@bbox <- bbox(points_spdf)


par(mar = c(1, 1, 3, 1))

# Plot countries map and color with grays
plot(countries_sp,
     col = gray(0.8),
     border = gray(0.7))
# Plot points
plot(points_spdf,
     pch = 20,
     col = points_spdf$type, 
     cex = sqrt(points_spdf$n)/2 + 0.25,
     add = TRUE)
# Add a box around the plot
box()

# Legend for colors
legend("topright",
       legend = levels(points_spdf$type),
       pt.cex = 2,
       col = 1:2,
       pch = 15)
# legend for size of points
legend("right",
       legend = pointsize,
       pt.cex = (sqrt(pointsize)/2 + 0.25),
       col = "black",
       pch = 20,
       title = "Letters")

# Title for the map
title(main = "Correspondence of Daniel van der Meulen, 1585")

# Create sf object with geo_data data frame and CRS
points_sf <- st_as_sf(geo_data, coords = c("lon", "lat"), crs = 4326)

# Getting the class of an sf object shows that it is based on tibble and data frame.
class(points_sf)

# Printing out an sf object is similar to tibble or data frame
points_sf

# Class of the geometry or sfc column
class(points_sf$geometry)

# Retrieve the geometry of an sf object
# to see coordinates, type of feature, and CRS
st_geometry(points_sf)
#install.packages('rgeos')
library(rgeos)
coast_sf <- ne_coastline(scale = "medium", returnclass = "sf")
countries_sf <- ne_countries(scale = "medium", returnclass = "sf")

# Print first six rows of coast_sf
head(coast_sf)

# Subset of locations with "n" greater than 10
filter(points_sf, n > 10)

#library(mosaic)
#library(latticeExtra)

# Asian countries with new CRS
countries_sf %>% 
  filter(continent == "Asia") %>% 
  dplyr::select(name) %>% 
  st_transform(crs = "+proj=moll +datum=WGS84")


# Return to default palette
palette("default")

# Map of Asian countries
countries_sf %>% 
  filter(continent == "Asia") %>% 
  dplyr::select(name) %>% 
  st_transform(crs = "+proj=moll +datum=WGS84") %>% 
  plot(key.pos = NULL, graticule = TRUE, main = "South America")
