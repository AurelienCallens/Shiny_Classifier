#This is the R code for a shiny application used for 
# image classification. It depends on a csv file which 
# contains a table with file path for every image. 
# Aurélien Callens 
# 14/04/2020


# 1) Read csv file (placed in the same repository of the applicati)
# 2) Select column with filepaths of images  
# 3) Resume previous classification by selecting a column with result or create new one
# 4) Classify images by pushing buttons
# 5) Save the results to the csv file with save button

library(shiny)
library(shinydashboard)
library(tidyverse)
library(EBImage)

# Allow shiny to import csv file > 5 mo
options(shiny.maxRequestSize = 30*1024^2)

dash_side <- dashboardSidebar(
    sidebarMenu(fileInput("file",
              "Choose CSV File",
              accept = c(
                  "text/csv",
                  ".csv")
              ),
              
              uiOutput("var_fp"), 
              uiOutput("var_cla")
    )
)
    
dash_body <- dashboardBody(
    
   
    fluidRow(
        column(12, align="center",
               h3(textOutput("test")) 
        )
    ),
    
    
    br(),
    
    imageOutput("imgPlot", width = "100%", height = "750px"),
    
    br(),
    fluidRow(
        column(12, align="center",
               actionButton("Swash", "Swash"),
               actionButton("Impact", "Impact"), 
               actionButton("Splash", "Splash"),
               actionButton("Overwash", "Overwash"),
               actionButton("Undefined", "Undefined")
        )
    ),
    br(),
    br(),
    fluidRow(
        column(12, align="center",
               actionButton("Save", "Save") 
        )
    )
    
)

dashboardPage(dashboardHeader(title = "Shiny image classifier"),
              dash_side,
              dash_body)


