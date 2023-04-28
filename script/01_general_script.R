# This map is one of the results of the AHRC project Prismatic Jane Eyre.
## It has been coded by Giovanni Pietro Vitali (Paris-Saclay University) with 
## Matthew Reynolds (University of Oxford), who is the PI of the project.
## Last update 5 December 2021

# Call the libraries
library(leaflet)
library(sp)
library(rgdal)
library(RColorBrewer)
library(leaflet.extras)
library(leaflet.minicharts)
library(htmlwidgets)
library(raster)
library(mapview)
library(leafem)
library(geojsonio)
  
  ## upload the data in Gojson and define the palette

  countries <- geojsonio::geojson_read("data/geojson/countries.geojson", what = "sp")

  pal <- colorBin("YlOrRd", domain = countries$annotation)
  
  ## upload the data in csv
  data <- read.csv("data/csv/pje_2023_04_28.csv")
  
  ## Create the map  object
  m <- leaflet(countries) %>% 
  
    ## Basemap
    addTiles() %>%
    ## Set the central view and zoom
    setView(lng = 0.80, 
            lat = 25.98, 
            zoom = 1 ) %>%
  
    ## Add markers from the csv with pop-up
    addMarkers(data = data, 
               lng = ~lng, 
               lat = ~lat,
               group = "Languages",
               popup = ~paste("<b>", label_place_of_publication, "</b>" ,"<br>", "<br>",
                              "Language:", "<b>", language,"</b>","<br>",
                              "Title:", "<b>", title, "</b>", "</b>","<br>",
                              "Translator:", "<b>", translator_s, "</b>","<br>",
                              "Date:", "<b>", date, "</b>", "<br>",
                              "Publisher:", "<b>", publisher, "</b>", "<br>",
                              "Country:", "<b>", country,"</b>","<br>",
                              "Known reprints & re-editions in the same place:", "<b>", dates_of_reprints, "</b>", "<br>",
                              "Notes:", "<b>", notes, "</b>", "<br>",
                              sep = " "),
               clusterOptions = markerClusterOptions()) %>%
  
    ## Add Polygon layer from the Geojson
    addPolygons(data = countries,
                fillColor = ~pal(countries$annotation),
                weight = 0.1,
                color = "brown",
                dashArray = "3",
                opacity = 0.7,
                stroke = TRUE,
                fillOpacity = 0.5,
                smoothFactor = 0.5,
                group = "Countries",
                label = ~paste(titles, ": ", annotation, " act(s) of translation", sep = ""),
                highlightOptions = highlightOptions(
                  weight = 0.6,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE))%>%
    
    ## Add a legend for the polygon layer based on its palette
    addLegend("bottomleft", pal = pal, values = ~annotation,
              title = "Acts of Translation",
              labFormat = labelFormat(suffix = " per country"),
              opacity = 1) %>%
    
   ## Add a legend for the map title
    addLegend("topright",
              colors = c("trasparent"),
              labels=c("www.prismaticjaneeyre.org"),
              title="Prismatic Jane Eyre") %>%
    
    ## Add a minimap to orient the user in zoom mode
    addMiniMap() %>%
    
    ## Add a zoom reset button
    addResetMapButton() %>%
    
    # Add the Layer control
     addLayersControl(baseGroups = c("Language"),
                      
                      overlayGroups = c("Countries"),
                      
                      options = layersControlOptions(collapsed = TRUE))
   
  ## Run the map
  m
  
  