library(tidyverse)
library(ggmap)

url = 'https://raw.githubusercontent.com/asifabdullah-git/R/master/GIS/data/chw_sample_bgd_upz.csv'

master_list <- read_csv(url)
master_list

upazilas <- distinct(master_list, NAME_4)
upazilas
upazilas <- rename(upazilas, place = NAME_4)
head(upazilas, n = 2)

upazilas_df <- as.data.frame(upazilas)


dis <- distinct(master_list, NAME_3)
dis
dis <- rename(dis, place = NAME_3)
head(dis, n = 2)

dis_df <- as.data.frame(dis)


register_google(key = "AIzaSyAfpkKRMkcAYFXrOMEhVyJsWY86FQFe4nU", write = TRUE)

locations_df1 <- mutate_geocode(dis_df, place)
locations_df1
#write_csv(locations_df1, "data/locations.csv")
#write_csv(locations_df1, "C:/Users/Asus/OneDrive/Desktop/JOB/Atunu_Sir/Data/location.csv")
locations <- as_tibble(locations_df1)


library(sf)
library(mapview)

locations_sf <- st_as_sf(locations, coords = c("lon", "lat"), crs = 4326)
mapview(locations_sf)



destinations <- distinct(letters, destination)
sources
destinations

cities <- full_join(sources, destinations, by = c("source" = "destination"))
cities

cities <- rename(cities, place = source)
head(cities, n = 2)

cities_df <- as.data.frame(cities)

register_google(key = "AIzaSyBbS3wTu2wXuhjRwSf2U5oK6NJrtyEt0bs", write = TRUE)

locations_df2 <- mutate_geocode(cities_df, place)
locations_df2
locations2 <- as_tibble(locations_df2)

library(sf)
library(mapview)

locations_sf2 <- st_as_sf(locations2, coords = c("lon", "lat"), crs = 4326)
mapview(locations_sf2)

map <- get_googlemap(center = c(8.4, 49.5), zoom = 6)
ggmap(map)
