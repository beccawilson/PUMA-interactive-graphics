#clear environment
rm(list=ls())

#load packages
library(leaflet)

#to make utf-8 -only need if not saved as utf-8
#studies[] <- lapply(studies2, function(x) if(is.character(x)) iconv(x, from = "", to = "UTF-8") else x)


# Icons
icons_list <- icons(iconUrl = "https://raw.githubusercontent.com/R-CoderDotCom/chinchet/main/inst/red.png", 
                    iconWidth = c(50), iconHeight = c(50))

studies <-read.csv("map_input.csv")

#for popup
studyname <- studies$Acronym
studies$popup_text <- paste0("<b>Study Name(s):</b> ", studies$Acronym, "<br><b>City:</b> ", studies$City, "<br><b>Country:</b>", studies$Country)


leaflet() %>%
  addTiles() %>%
  setView(lng = 12.43, lat = 42.98, zoom = 1) %>%
  addMarkers(lng = studies$Lng, lat = studies$Lat, icon = icons_list, popup = studies$popup_text)


