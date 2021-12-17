
shinyUI(fluidPage(
    

    
    # Application title
    titlePanel("Statistiques descriptives du dataset Bonheur, avec R Shiny et Shiny Apps"),
    
    # Sidebar with controls 
    sidebarLayout(
        sidebarPanel(
            h3("Choix des donnees"),
            selectInput("bonheur", "Choisir un echantillon :", 
                        choices = c("Toute la base", "Bonheur faible", "Bonheur moyen", "Bonheur fort")),
            selectInput("Xvar", "Variable X", 
                        choices = c("score_bonheur", "corruption", "chomage", "PIB_habitant", "esp_vie", "tourisme", "pollution", "internet", "dep_militaires")),
            selectInput("Yvar", "Variable Y", 
                        choices = c("score_bonheur", "corruption", "chomage", "PIB_habitant", "esp_vie", "tourisme", "pollution", "internet", "dep_militaires"), selected = "score_bonheur"),
            numericInput("obs", "Nombre de pays a observer :", 10),
            h3("K-Means"),
            numericInput("clusters", "Nombre de clusters", 3, min = 1, max = 9),
            h3("DBSCAN"),
            sliderInput("vois", "Rayon de voisinage de chaque point", min = 0.0, max = 1.0, value = 0.2),
            sliderInput("minPoints", "Nombre de voisins au sein du rayon", min = 0, max = 10, value = 3),
            h3("Base niveau de bonheur"),
            downloadButton("downloadData", "Download 'Bonheur.csv'", class = NULL),
           ),

        
        # MainPanel divided into many tabPanel
        mainPanel(
            tabsetPanel(
                tabPanel("Plot", h1("Nuage de points"), plotOutput("simplePlot"), h1("Boite a moustache"), plotOutput("boxPlot")),
                tabPanel("Statistiques descriptives", h1("Statistiques descriptives"),verbatimTextOutput("summary")),
                tabPanel("Table", h1("Table"), textOutput("NbRows"), tableOutput("view")),
                tabPanel("Clustering", h1("K-Means"), textOutput("NbClust"), plotOutput("kmeansPlot"), 
                         h1("Cluster base sur la densite (DBSCAN)"), textOutput("dbscan_Param"), plotOutput("dbscanPlot"),
                         h1("Arbre de decision"), plotOutput("treePlot"))
            ) 
        )
    )
))