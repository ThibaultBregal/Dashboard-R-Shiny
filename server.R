library(datasets)
library(rpart)
library(party)
library(fpc)
library(tidyverse)
library(dashboardthemes)

# install.packages("dashboardthemes")
# install.packages("shinydashboard")

# Import de la base de donnees Bonheur
# bonheur <- read.csv2("C:/Users/tibre/OneDrive/Bureau/Dashboard/Bonheur.csv")
# bonheur$niveau_bonheur <- as.factor(bonheur$niveau_bonheur)


# On definit la palette de couleurs que l'on va utiliser dans nos graphes
palette(c("#E73032", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFDD33", "#A65628", "#F781BF", "#999999"))

# Define server logic 
shinyServer(function(input, output) {
    
    datasetInput <- reactive({
        switch(input$bonheur,
               "Toute la base" = bonheur,
               "Bonheur faible" = subset(bonheur, bonheur$niveau_bonheur == "faible"),
               "Bonheur moyen" = subset(bonheur, bonheur$niveau_bonheur == "moyen"),
               "Bonheur fort" = subset(bonheur, bonheur$niveau_bonheur == "fort"))
    })
    
    colX <- reactive({
        switch(input$Xvar,
               "Score bonheur" = bonheur$score_bonheur,
               "Corruption" = bonheur$corruption,
               "Chomage" = bonheur$chomage,
               "PIB par habitant" = bonheur$PIB_habitant,
               "Esperance de vie" = bonheur$esp_vie,
               "Tourisme" = bonheur$tourisme,
               "Pollution" = bonheur$pollution,
               "Acces a Internet" = bonheur$internet,
               "Depenses militaires" = bonheur$dep_militaires)
    })
    
    colY <- reactive({
        switch(input$Yvar,
               "Score bonheur" = bonheur$score_bonheur,
               "Corruption" = bonheur$corruption,
               "Chomage" = bonheur$chomage,
               "PIB par habitant" = bonheur$PIB_habitant,
               "Esperance de vie" = bonheur$esp_vie,
               "Tourisme" = bonheur$tourisme,
               "Pollution" = bonheur$pollution,
               "Acces a Internet" = bonheur$internet,
               "Depenses militaires" = bonheur$dep_militaires)
    })
    
    clusters <- reactive({
        kmeans(bonheur[,c(4:12)], input$clusters)
    })
    
    myColors <- reactive({
        switch(input$bonheur,
               "Toute la base" = c(palette()[1],palette()[2],palette()[3]),
               "Bonheur faible" = palette()[1],
               "Bonheur moyen" = palette()[2],
               "Bonheur fort" = palette()[3])
    })
    
    # Faire un summary sur la base => afficher les stats descriptives de nos variables 
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
    })
    
    # Montrer les premieres n observations
    output$view <- renderTable({
        head(datasetInput(), n = input$obs)
    })
    output$NbRows <- renderText({ 
        paste("Vous avez choisi d'afficher ", input$obs," lignes.")
    })
    
    
    # Affichage d'un plot simple lineaire a deux entrees
    output$simplePlot <- renderPlot({
        
        df_bonheur <- datasetInput()
        plot(df_bonheur[,c(input$Xvar,input$Yvar)], xlab = input$Xvar, ylab = input$Yvar,
             main=toupper(ifelse(input$dataset == "Toute la base", "bonheur", input$dataset)), pch=16, cex = 2,
             col = ifelse(df_bonheur$niveau_bonheur == "faible", palette()[1], 
                          ifelse(df_bonheur$niveau_bonheur == "moyen", palette()[2], palette()[3])) )
        
        legend("bottomright", legend = unique(df_bonheur[,3]), 
               col = myColors(), title = expression(bold("Niveau_bonheur")),
               pch = 16, bty = "n", pt.cex = 2, 
               cex = 0.8, text.col = "black", horiz = FALSE, inset = c(0.05, 0.05))
    })
    
    # Affichage des boites a moustache
    output$boxPlot <- renderPlot({
        df_bonheur <- datasetInput()
        
        if (input$bonheur == "Toute la base") {
            boxplot(df_bonheur[,c(input$Yvar)] ~ df_bonheur[,3], xlab = "niveau_bonheur", ylab = input$Yvar, main = "bonheur", 
                    border = "black", col = myColors())
        }
        else {
            boxplot(df_bonheur[,c(input$Yvar)], xlab = "niveau_bonheur", ylab = input$Yvar, main = toupper(input$dataset),
                    border = "black", col = myColors())
        }
    })
    
    # Graphe methode des K-means
    output$NbClust <- renderText({ 
        paste("Methode des K-means appliquee avec ", input$clusters," classes.")
    })
    output$kmeansPlot <- renderPlot({
        plot(bonheur[,c(input$Xvar,input$Yvar)],
             col = clusters()$cluster,
             pch = 20, cex = 2)
        points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    })
    
    # Clustering par la densite
    output$dbscan_Param <- renderText({ 
        paste("Clustering DBSCAN applique avec un rayon de ", input$vois," et un nombre de voisins de ", input$minPoints,".")
    })
    output$dbscanPlot <- renderPlot({
        cluster <- dbscan(bonheur[,-c(1,3)], eps = input$vois, MinPts = input$minPoints)
        plot(cluster, bonheur[,c(input$Xvar, input$Yvar)])
    })
    
    # Arbre de decision
    output$treePlot <- renderPlot({
        ctree <- ctree(niveau_bonheur ~ dep_militaires + corruption + mort_5 + chomage + PIB_habitant + esp_vie +
                           pollution + internet + tourisme, data = bonheur)
        plot(ctree, type="simple")
    })
    
    # Creation d'un dataframe en format .csv avec les donnees de notre base bonheur dedans
    output$downloadData <- downloadHandler(
        filename = function() {
            paste('data-bonheur-', Sys.Date(), '.csv', sep='')
        },
        content = function(con) {
            write.csv(bonheur, con)
        }
    )
    
})
