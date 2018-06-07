# This is the server logic to build a Shiny application. The application takes an address
#of a property alongside 3 binar;y factors (old or new build, flat or terrace, leasehold or
#freehold) and predicts the properties price using a k-nearest neighbours model.
#The location of the property is plotted alongide the data used to build the model.

library(shiny)
library(ggmap)
library(leaflet)
library(caret)
knnModel <- load("C:/Users/jonat/Documents/Coursera/Data Science/9. Developing data products/Week 4 assignment/knn_fit.Rda")

shinyServer(function(input, output) {

  
observeEvent(input$calculate, {
  geoObj <-  geocode(location = input$pAddress)
  output$inputLatLng <- renderText({
   
    
  paste("Latitude:",  as.character(geoObj[2]), "Longitude:", as.character(geoObj[1]))
    
    })
  
  output$predictedPrice <- renderText({
    a <- as.numeric(input$hType)
    b<- as.numeric(input$newBuild)
    c<- as.numeric(input$freeHold)
    d<- as.numeric(geoObj[1])
    e<- as.numeric(geoObj[2])
    predictorframe <- data.frame(a,b,c,d,e)
    predictorNames <- c("Terraced","Old","Freehold","lng","lat")
    colnames(predictorframe) <- predictorNames

   predictedvalue <- predict(knn_fit, newdata = predictorframe)

paste("The kNN model-predicted value of the property is: £",as.integer(predictedvalue), sep = "")


  })
    
  output$leafletPlot <- renderLeaflet({
  
    
    map_price_data <- knn_fit$trainingData$.outcome
    lat_data <- knn_fit$trainingData$lat  
    lng_data <-knn_fit$trainingData$lng    
   htype_data <- ifelse(knn_fit$trainingData$Terraced == 1, "Terraced", "Flat")
   newBuild_data <- ifelse(knn_fit$trainingData$Old == 1, "New Build", "Old Build")
    freehold_data <- ifelse(knn_fit$trainingData$Freehold == 1, "Freehold", "Leasehold")

    leaflet() %>% addTiles() %>% 
      addMarkers(lng = as.vector(lng_data), lat = as.vector(lat_data),
                 popup = paste("Price: £",map_price_data ,",", htype_data,
                               ",", newBuild_data,
                               ",",freehold_data)) %>%
      addCircleMarkers(lng = as.numeric(geoObj[1]),lat = as.numeric(geoObj[2]), radius = 10,
                                            color = '#C00', opacity = 1, fillOpacity = 1) %>%
setView(lng = as.numeric(geoObj[1]),lat = as.numeric(geoObj[2]), zoom = 15)
     
    
    
    
  })
  
  
  })
  
  
})
  
  



