library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(ggmap)
library(d3heatmap)
library(shinyjs)
library(shinyWidgets)

shinyUI(
  div(id="house",
      
      navbarPage("Manhattan House Finder",
        #strong("Manhattan House Finder",style="color: white;"), 
                 theme=shinytheme("flatly"),
                 #theme = "bootstrap.min.css",
                 #theme="styles.css",
                 
        tabPanel("Intro",icon = icon("home"),
                 
                 mainPanel(width=12,
                           setBackgroundImage(
                             src = "../City.png"),
                           
                           style = "color: black",
                           
                           h2("Discover sold homes and properties to find your ideal home in Manhattan.", align = "center"),
                           div(class="header", "Group Project by Shuxin Chen, Junyan Guo, Xiyao Yan, Ziqin Zhao, Marsya Chairuna",align = "center"),
                           p(em(a("Github link",href="https://github.com/TZstatsADS/Spring2020-Project2-group3")), align = "center"),
                           p(""),
                           h3("Manhattan House Finder will help you find localize insights on every listing."),
                           p("Finding the process of looking for homes and properties in Manhattan inefficient? Feeling like your landlords and agents charged you unreasonably high pricing given a bare minimum specification? Feeling familiar with any one of these issues? Manhattan House Finder got you."),
                           p("We will help you benchmark based on discover sold homes for your home search journey based on the criteria you most care about - catered to your lifestyle."),
                           tags$div(tags$ul(
                             tags$li("Price: The sales price of a home/property."),
                             tags$li("Square Feet: The square footage or area, is the size of a lot or the floor space of a building or any other piece of real estate or property. "),
                             tags$li("School: The list or proximity of schools around the home or property, including early childhood, K-8, K-12, elementary, junior High, senior high school, etc. (Higher index is favorable)"),
                             tags$li("Park: The list or proximity of famous landmark or park around the home or property. (Higher index is generally preferrable)"),
                             tags$li("Bus and Subway: The list or proximity of bus terminal or subway station around the home or property. (Higher index is generally preferrable)"),
                             tags$li("Restaurant: The list or proximity of restaurants around the home or property. (Higher index is generally preferrable)"),
                             tags$li("Retail: The list or proximity of food retails (i.e. Whole Foods, etc.) around the home or property, including small, medium, and large retails. (Higher index is generally preferrable)"),
                             tags$li("Crime: The list or proximity of pastcrimes around the home or property. (Lower index is generally preferrable)"),
                             tags$li("Noise: The list of past source of noise surrounding the area of home or property. (Lower index is generally preferrable)"),
                           )),
                           
                           h3("Evaluation"),
                           h4("Index"),
                           p("We provide an index value representing each of the criteria above for each property. A higher index shows that the surrounding area around a particular property has a higher density of the selected criteria. For example, if Property A has a high index of criteria 'School', we can infer that there are many schools around the area of property A."),
                           tags$div(tags$ul(
                             tags$li("For criteria school, park, bus and subway, restaurant, and retail, a higher index is generally preferrable."),
                             tags$li("For criteria crime and noise, a lower index is preferrable.")
                           )),
                           h4("Rank"),
                           p("To help users compare a same index between two properties, we provide a rank where indexes are sorted descendingly from the most preferrable condition to the least preferrable condition. For example, the area around Columbia University has a rank of 4% for crime and 82% for retail. This can be read as Columbia University is within the top 4% in terms of the least number of crime, and at top 82% for the most number of retail."),
                           
                           h3("Target Users"),
                           h4("Based on price sensitivity"),
                           strong("The Affordable Housing and Middle-Income Users"),
                           p("Users whose utmost priority are economical price. These customers have tendency to be more flexible in terms of their non-cost selection criteria such as proximity to subway station, landmarks, schools, etc."),
                           strong("The Lifestyle Users"),
                           p("Established users whose priority are good services and ammenities. They are willing to pay extra to get to live in strategic residential location."),
                           h4("Based on location flexibility"),
                           strong("Flexible Users"),
                           p("Users with minimum to no preference in their house/property locations, usually as long as they get the most economical prices."),
                           strong("Constrained Users"),
                           p("Users who need to live specifically in certain boroughs/neighborhood because of occupation constraint."),
                           p(em(a("Source: Landlord.com",href="http://www.landlord.com/renter_demographics.htm"))),
                           
                           h3("Instructions by Tab"),
                           h4("Map"),
                           p("This page features a browser map. Users can pick from multiple information filters (e.g., bus and subway station, park, restaurant, etc.) to understand the generalized information in their pinpointed areas."),
                           h6("Recommended for all users."),
                           h4("Statistics"),
                           p("This page features a quick comparison between Manhattan neighborhoods based on the count of non-cost indexes i.e., the number of schools or parks in a particular neighborhood."),
                           h6("Recommended for all users."),
                           h4("Recommendation"),
                           p("This page includes a filtering feature where users can browse the list of houses/properties recommendation based on both cost and non-cost criteria that they choose."),
                           h6("Recommended for Flexible and Affordable Housing Users."),
                           h4("Evaluation"),
                           p("This page includes a location search feature where users can type in their prospective address as an input (e.g., school address). The engine will help tenants get a summarized information of residential listings around that address."),
                           h6("Recommended for Constrained and Lifestyle Users.")
                           
                           
                 )),
                 
                 tabPanel("Map",icon = icon("map-marker-alt"),
                          #tags$head(
                             # Include our custom CSS
                            #includeCSS("styles.css")
                          #),
                          div(class="outer",
                              leafletOutput("map",width="100%",height=850),
                              
                              
                              absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                            top = 170, left = 20, right = "auto", bottom = "auto", width = 320, height = "auto",
                                            
                                            useShinyjs(),
                                            ##Possible to change to subway station and bus station
                                            checkboxGroupInput("enable_markers", "Traffic:",
                                                               choices = c("Bus Station","Subway Station"),
                                                               selected = c("Subway Station")),
                                            
                                            checkboxGroupInput("click_neighbourhood", "Neighbourhood",
                                                               choices =c("Crime","Noise","Park","Restaurant","Retail","School"), selected =c()),
                                            
                                            sliderInput("click_radius", "Radius of area around  the selected address", min=50, max=500, value=250, step=10),
                                            
                                            style = "opacity: 0.80"
                              ),
                              
                              
                              #the panel on the right to show the statistics
                              absolutePanel(id = "Statistics", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                            top = 90, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto", style = "overflow-y:scroll;height:500px;max-height:550px",
                                            style = "opacity: 0.70", 
                                            
                                            useShinyjs(),
                                            
                                            h3("Summary of Chosen Area"),
                                            
                                            h4("The Geographical Information"),
                                            p(textOutput("click_coord")),
                                            
                                            h4("Average House Price/Square Feet"),
                                            p(strong(textOutput("click_avg_price_red", inline = T))),
                                            tags$head(tags$style("#click_avg_price_red{color: red;
                                            font-size: 20px;
                                            font-style: italic;
                                            }"
                                            )
                                            ),
                                            p(strong(textOutput("click_avg_price_orange", inline = T))),
                                            tags$head(tags$style("#click_avg_price_orange{color: orange;
                                            font-size: 20px;
                                            font-style: italic;
                                            }"
                                            )
                                            ),
                                            p(strong(textOutput("click_avg_price_green", inline = T))),
                                            tags$head(tags$style("#click_avg_price_green{color: green;
                                            font-size: 20px;
                                                                 font-style: italic;
                                                                 }"
                                            )
                                            ),
                                            div(p(">1221.48 (3rd quantile);"),style = "color:red;font-size:12px"),
                                            div(p("<70.92 (1st quantile);"),style = "color:green;font-size:12px"),
                                            
                                            h4("Crime Nearby"),
                                            plotlyOutput("crime"),
                                            
                                            h4("Noise Nearby"),
                                            plotlyOutput("noise"),
                                            
                                            h4("Parks Nearby"),
                                            div(tableOutput("park"), style = "font-size:60%"),
                                            
                                            h4("Restaurants Nearby"),
                                            div(tableOutput("restaurant"), style = "font-size:60%"),
                                            
                                            h4("Retails Nearby"),
                                            div(tableOutput("retail"), style = "font-size:60%"),
                                            
                                            h4("Schools Nearby"),
                                            div(tableOutput("school"), style = "font-size:60%")
                                            
                                            
                              )
                          )        
                 ),
                 
                 tabPanel("Statistics",icon = icon("chart-line"),
                          fluidPage(
                            div(class="outer",
                                sidebarLayout(
                                  sidebarPanel(div(id="facilities",style = "width: 80%;font-size:80%",
                                                   pickerInput("check_neighbor","Select the neighborhood(s) you want to examine.", choices = c("UPPER WEST SIDE", "MIDTOWN EAST", "MIDTOWN WEST", 
                                                                                                                                               "MAHATTAN NORTH", "LOWER MANHATTAN WEST", "HARLEM", "UPPER EAST SIDE", 
                                                                                                                                               "LOWER MANHATTAN EAST", "MIDTOWN CBD", "WASHINGTON HEIGHTS & NORTH", "FINANCIAL DISTRICT"),options = list(`actions-box` = TRUE),multiple=T,
                                                               selected = list("UPPER WEST SIDE", "MIDTOWN EAST", "MIDTOWN WEST")),
                                                   tags$style('#check_neighbor{font-size:80%}'),
                                                   selectInput("check_index","Select the criteria.",list("price","sold","feet","school","park","subway","bus","restaurant","retail","crime","noise"),multiple=FALSE,
                                                               selected = list("price","sold","feet","school","park","subway","bus","restaurant","retail","crime","noise")),
                                                   tags$style('#check_index{font-size:80%}')
                                  )
                                  ),
                                  mainPanel(
                                    plotlyOutput("stat_plot"),
                                    plotlyOutput("monthly_plot")
                                  )
                                )
                            )
                          ) ),
                 
                 tabPanel("Recommendation",icon=icon("edit"),
                          
                          fluidPage(
                            
                            
                            fluidRow(
                              column(6,
                                     h1("Choose What You Prefer"))
                            ),
                            
                            fluidRow(
                              column(3,
                                     sliderInput("price", "Housing Price(Per SqFt):",min = 70, max = 20740, value = 230)),
                              column(3,
                                     sliderInput("size", "Square Feet:",min = 500, max = 149560, value = 16000)),
                              column(3, 
                                     selectInput("zone", label = h5("Living Zone:"),
                                                 choices = list("Choose Preferred Living Zone"="", "UPPER WEST SIDE", "MIDTOWN EAST", "MIDTOWN WEST", 
                                                                "MAHATTAN NORTH", "LOWER MANHATTAN WEST", "HARLEM", "UPPER EAST SIDE", 
                                                                "LOWER MANHATTAN EAST", "MIDTOWN CBD", "WASHINGTON HEIGHTS & NORTH", "FINANCIAL DISTRICT"),
                                                 multiple = T))),
                            
                            fluidRow(
                              column(3,
                                     
                                     selectInput("rest_type",label = h5("Restaurant"),
                                                 choices = list("Choose Favorite Food"="", "American", "Asian", "Mediterranean", "Middle Eastern",
                                                                "Vegetarian", "Sandwiches/Soups", "Latin", "Africa",
                                                                "Italian", "European", "Others", "Café/Bakery/Drinks"),
                                                 multiple = T)),
                              column(3,
                                     selectInput("school", label = h5("School"), 
                                                 p("Current Value:", style = "color:black"),
                                                 choices = list("Don't care" = 0 , 
                                                                "A little bit" = 0.7714286 ,
                                                                "Important!" = 1.542857))),
                              column(3,
                                     selectInput("crime", label = h5("Safety"),
                                                 p("Current Value:", style = "color:black"),
                                                 choices = list(" Safety is really important!"= 1.5,
                                                                "A little bit" = 2.5,
                                                                "I have superpower" = 3
                                                                
                                                 ))),
                              
                              column(3,
                                     selectInput("retail", label = h5("Retail"),
                                                 p("Current Value:", style = "color:black"),
                                                 choices = list("Just online shopping"= 0 , 
                                                                "Needs some markets"= 0.872364,
                                                                "I love going shopping everyday!" = 1.197558)
                                                 
                                     )),
                            ),
                            
                            
                            fluidRow(
                              column(3,
                                     selectInput("subway",label = h5("Subway"),
                                                 p("Current Value:", style = "color:black"),
                                                 choices = list("No need"= 0 , 
                                                                "Sometimes Need"= 0.6136364 ,
                                                                "Necessary! " = 1.022727))),
                              column(3,
                                     selectInput("bus",label = h5("Bus"),
                                                 p("Current Value:",style = "color:black"),
                                                 choices = list("I have my own car"= 0 , 
                                                                "Sometimes need" = 0.5 ,
                                                                "Necessary! "= 1))),
                              
                              column(3,
                                     selectInput("park",label = h5("Park"),
                                                 p("Current Value:", style = "color:black"),
                                                 choices = list("I just want stay at home"= 0.1 , 
                                                                "Yes, park is good but not really necessary" = 0.6 ,
                                                                "Everyday, I need go to park! "= 1 ) )),
                              column(3,
                                     selectInput("noise",label = h5("Noise"),
                                                 p("Current Value:", style = "color:black"),
                                                 choices = list("Don't matter"= 3,
                                                                "I need a relatively quiet house!" = 2 ,
                                                                "I want a quiet house!"= 1.5)))
                            ),
                            hr(),
                            fluidRow(
                              column(6,
                                     leafletOutput("mymap",height=500)),
                              column(6,
                                     dataTableOutput("recom"),style = "color:black")
                            )
                          )),

                 tabPanel("Evaluation",icon = icon("cog"),
                          fluidPage(
                            fluidRow(
                              column(5,textInput("caption", "Search Google Maps", "50W 97th Street",width=600)),
                              column(3,sliderInput("range", "Preferred Foot Square:",min = 436, max = 149560, value = c(40000,100000))),
                              column(3,sliderInput("prange", "Price Interval:",min = 2500, max = 416100000, value = c(100000000,300000000)))
                            ),
                            h3("Index Evaluation:"),
                            tableOutput("score"),
                            h3("Similar Houses:"),
                            dataTableOutput("like"),
                            h3("Nearest High Score Houses:"),
                            dataTableOutput("near"),
                            h3("Potential Houses:"),
                            dataTableOutput("potential")
                          )),
                 tabPanel("Source",icon = icon("cloud-download"),
                          mainPanel(setBackgroundImage(
                            src = "https://images.squarespace-cdn.com/content/v1/5b16f1b3b27e39a160a8f256/1561760504190-W36MULRW8IWVMYCP18E0/ke17ZwdGBToddI8pDm48kDITAuO7WvGYe_HtkNx7UXUUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcQbIjqAfhDXNkvlGRG3YzfcUFWQufmCUNtpzqkVhTQlW_0KK_D1La8oUscKbt8gvv/City+-+low+opacity.png?format=2500w"
                          ),
                          
                          style = "color: black",
                          
                          navlistPanel(
                            tabPanel("Data",
                                     h3("Data can be found at NYC Open Data and MTA Website",style = "font-size:110%"),
                                     h1(" "),
                                     p(em(a("Housing Data",href="https://catalog.data.gov/dataset/nyc-citywide-annualized-calendar-sales-update"))),
                                     p(em(a("Noise(311 Compliance Data)",href="https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9"))),
                                     p(em(a("Parks Data",href="https://data.cityofnewyork.us/City-Government/Parks-Properties/k2ya-ucmv#revert"))),
                                     p(em(a("Traffic_Subway Station",href="https://data.cityofnewyork.us/Transportation/Subway-Stations/arq3-7z49"))),
                                     p(em(a("Traffic_Bus Station",href="http://web.mta.info/developers/developer-data-terms.html#data"))),
                                     p(em(a("Retail",href="https://data.ny.gov/Economic-Development/Retail-Food-Stores/9a8c-vfz"))),
                                     p(em(a("Restaurant",href="https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j"))),
                                     h1(" "),
                                     p(em(a("Github link for the project",href="https://github.com/TZstatsADS/Spring2020-Project2-group3")))
                            ),
                            tabPanel("Contact",
                                     h3("Contact us if you are interested in the project!",style = "font-size:110%"),
                                     h1(" "),
                                     fluidPage(fluidRow(column(2,div(style = "vertical-align:top",img(src ="https://image.flaticon.com/icons/svg/2107/2107224.svg",height = 30,width=30))),
                                                        column(9,div(style = "vertical-align:top",p(em(paste(" Xiyao Yan:"," xy2431@columbia.edu")))))),
                                               h2(" "),
                                               fluidRow(column(2,div(style = "vertical-align:top",img(src ="https://image.flaticon.com/icons/svg/1820/1820850.svg",height = 30,width=30))),
                                                        column(10,div(style = "vertical-align:top",p(em(paste(" Shuxin Chen:"," sc4599@columbia.edu")))))),
                                               h2(" "),
                                               fluidRow(column(2,div(style = "vertical-align:top",img(src ="https://image.flaticon.com/icons/svg/477/477110.svg",height = 30,width=30))),
                                                        column(10,div(style = "vertical-align:top",p(em(paste(" Junyan Guo:"," jg4184@columbia.edu")))))),
                                               h2(" "),
                                               fluidRow(column(2,div(style = "vertical-align:top",img(src ="https://image.flaticon.com/icons/svg/603/603533.svg",height = 30,width=30))),
                                                        column(10,div(style = "vertical-align:top",p(em(paste(" Marsya Chairuna:"," mc4813@columbia.edu")))))),
                                               h2(" "),
                                               fluidRow(column(2,div(style = "vertical-align:top",img(src ="https://image.flaticon.com/icons/svg/1887/1887135.svg",height = 30,width=30))),
                                                        column(9,div(style = "vertical-align:top",p(em(paste(" Ziqin Zhao:"," zz2709@columbia.edu")))))))
                                     
                                     )
                          )
                          
                          )) 
                 
      )
  )
)


