# This is the user interface part of a Shiny application. The application takes an address
#of a property alongside 3 binar;y factors (old or new build, flat or terrace, leasehold or
#freehold) and predicts the properties price using a k-nearest neighbours model.
#The location of the property is plotted alongide the data used to build the model.
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("London Borough of Lambeth: Property Value Predictor"),
  
  # Sidebar with text, radio button, and action button input
  sidebarLayout(
    sidebarPanel(
      h3("Inputs"),
      p("Enter an address from within the London Borough of Lambeth. Use the radio buttons
        to answer questions regarding the type of property. When you are ready click 
        'Predict Value and Show Neighbours'. THis will predict the sale price of the property and
plot it on a map alongside recently sold  properties in the same area.
You may have to press the button several times for the app to work."),
       textInput("pAddress", p("Residential address in Lambeth \n
(e.g.'1 Brixton Hill SW2 1HJ)
'"), 
                 value = "1 Endymion road SW2 1HX"),
       radioButtons("hType", p("House type?"),
                    choices = list("Terraced" = 1, "Flat/Maisonette" = 0),selected = 1),
       radioButtons("newBuild", p("New Build?"),
                    choices = list("Yes" = 1, "No" = 0),selected = 1),
    radioButtons("freeHold", p("Freehold?"),
                 choices = list("Yes" = 1, "No" = 0),selected = 1),
       actionButton("calculate","Predict Value and Show Neighbours")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        strong(textOutput("predictedPrice")),
        p("The red dot shows the location of the user-entered address. Other markers show 
          recent property sales in the area. Click on the markers for details of the sold
          property."),
       leafletOutput("leafletPlot"),
       textOutput("inputLatLng"),
       p("Contains HM Land Registry data © Crown copyright and database right 2018.
         This data is licensed under the Open Government Licence v3.0")
    ))
  )
)
