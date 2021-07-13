#------------------------------------------------------------------------

#                   UI, or "User Interface" Script

# this script designs the layout of everything the user will see in this Shiny App
#------------------------------------------------------------------------


library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)


# make dashboard header
header <- dashboardHeader(
    title = " Characterizing Connectivity Pinch-Points in Edmonton's Ribbon of Green",
    titleWidth = 800 # since we have a long title, we need to extend width element in pixels
)


# create dashboard body - this is the major UI element
body <- dashboardBody(

# make first row of elements (actually, this will be the only row)
fluidRow(
    
    # make first column, 25% of page - width = 3 of 12 columns
    column(width = 5,
           
           
           # Box 1: text explaining what this app is
           #-----------------------------------------------
           box( width = NULL,
                status="primary", # this line can change the automatic color of the box. options are "info", "primary","warning","danger', and "success"
                title = NULL,
                
                # background = "black",
                
                # add some text in bold
                strong("River Valley Connectivity Project"  ,
                # linebreak
                
                br(),       
                       
                       a("A sustainability scholars project", href="https://www.ualberta.ca/sustainability/experiential/sustainability-scholars/index.html", target = "_blank"),
                       ),
                
                # linebreak
                br(),
                
                # text in normal
                p("This application can be used to help visualize the biophysical conditions contributing to 
                  movement pinch-points in Edmonton's River valley"),
                p("Created by Brendan Casey.",  
                  br(),
                  strong(a("See application code", href="https://github.com/bgcasey/RV_connectivity",  target = "_blank")),
                br(),
                strong(a("See project workflow", href="https://bookdown.org/bgcasey/RV_connectivity",  target = "_blank"))),
                # 
                
           ), # end box 1
           
           
           # box 2 : input for selecting pinch-points and variables
           #-----------------------------------------------
           box(width = NULL, status = "primary",
               title  = "Selection Criteria", solidHeader = T, 
               collapsible = T,
               
               # Widget specifying the seasonal pinch-points to be included on the plot
               checkboxGroupButtons(
                   inputId = "season_select",
                   label = "Season",
                   choices = c("Winter" , "Summer"),
                   checkIcon = list(
                       yes = tags$i(class = "fa fa-check-square", 
                                    style = "color: steelblue"),
                       no = tags$i(class = "fa fa-square-o", 
                                   style = "color: steelblue"))
               ), # end checkboxGroupButtons
               
               
               # Widget specifying the Ribbon of Green reach
               checkboxGroupButtons(
                   inputId = "RoG_reach_select",
                   label = "RoG reach",
                   choices = c("Big Island Woodbend", "Big Lake", "Blackmud", "Cameron Oleskiw River Valley", 
                               "Confluence", "East Ravines", "Edmonton East", "Horsehills North", "Horsehills South", 
                               "Irvine Creek to Blackmud South", "Marquis River Valley", "Mill Creek North", "Mill Creek South", 
                               "North Saskatchewan Central", "North Saskatchewan East", "North Saskatchewan West", 
                               "SW Annex", "Wedgewood Ravine", "Whitemud", "Whitemud North", "Whitemud South Annex"),
                   checkIcon = list(
                       yes = tags$i(class = "fa fa-check-square", 
                                    style = "color: steelblue"),
                       no = tags$i(class = "fa fa-square-o", 
                                   style = "color: steelblue"))
               ), # end checkboxGroupButtons
               
               # Widget specifying the species to be included on the plot
               checkboxGroupButtons(
                   inputId = "variable_select",
                   label = "Variable of interest",
                   choices = c("Distance to road" , "Slope" , "Vegetation type" ,   "UPLVI STYPE" ,    "Volcanic Field",
                               "Complex" , "Other",   "Lava Dome"  , "Submarine"    ),
                   checkIcon = list(
                       yes = tags$i(class = "fa fa-check-square", 
                                    style = "color: steelblue"),
                       no = tags$i(class = "fa fa-square-o", 
                                   style = "color: steelblue"))
               ), # end checkboxGroupButtons
               
               
               # strong("Space for your additional widget here:"),
               # 
               # br(), br(), br(), br(), br(), # add a bunch of line breaks to leave space. these can be removed when you add your widget
               # 
               # # space for your addition here:
               #-------------------------------------------
               # --- --- --- ---   HINT   --- --- --- --- 
               # here, you will paste code for another Widget to filter volcanoes on the map.
               # you'll need to paste code for some widget, name it, then call it at the top of the server page
               # when we are filtering the selected_volcanoes() reactive object. 
               
               
               # see the columns in the volcanoes dataset, and add a widget to further filter your selected_volcanoes() server object
               #  --- --- --- some suggestions: --- --- ---
               # 1. slider bar to only show volcanoes population_within_30_km > xxxx 
               # 2. slider input to show volcanoes with last_eruption_year > xxxx
               # 3. slider input to only show volcanoes with elevation > xxxx
               # 4. checkbox input to only show volcanoes in  evidence category c("xx", "xx")
               
               # see available widgets here: http://shinyapps.dreamrs.fr/shinyWidgets/
               # and here: https://shiny.rstudio.com/gallery/widget-gallery.html
               
               
           ), # end box 2
           
           
           
           # box 3: ggplot of selected volcanoes by continent
           #------------------------------------------------
           box(width = NULL, status = "primary",
               solidHeader = TRUE, collapsible = T,
               title = "Volcanoes by Continent",
               plotOutput("continentplot", # this calls to object continentplot that is made in the server page
                          height = 325)
           ) # end box 3
           
    ), # end column 1
    
    

    # second column - 75% of page (8 of 12 columns)
    #--------------------------------------------------
    column(width = 7,
           
           # Box 3: leaflet map
           box(width = NULL, background = "light-blue", 
               leafletOutput("pinchPoint_map", height = 850) 
               # this draws element called "pinchPoint_map", which is created in the "server" tab
           ) # end box with map
    ) # end second column
    
), # end fluidrow

# Make a CSS change so this app shows at 90% zoom on browsers
# only adding this because it looked more zoomed in on my web browser than it did on my RStudio viewer
tags$style(" body {
    -moz-transform: scale(0.9, 0.9); /* Moz-browsers */
    zoom: 0.9; /* Other non-webkit browsers */
    zoom: 90%; /* Webkit browsers */}"),

) # end body


# compile dashboard elements
dashboardPage(
    skin = "blue",
    header = header,
    sidebar = dashboardSidebar(disable = TRUE), # here, we only have one tab, so we don't need a sidebar, we will just disable it. 
    body = body
)

