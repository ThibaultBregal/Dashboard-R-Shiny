# Dashboard-R-Shiny
Projet de Data Viz, sous la direction de Mme. Pauline VAISSIE

Équipe : SUAU Gwendal et BRÉGAL Thibault, M2 EKAP.

## Problématique
L'objectif de ce projet était de créer un tableau de bord interractif à partir d'un jeu de données et à l'aide du package R Shiny de R. Cela pour permettre la compréhension / visualisation d'une base de données d'étude.


## Base de données utilisée
Le jeu de données à partir duquel nous avons décidé d'élaborer notre dashboard est un échantillon d'une base utilisée pour mon mémoire de validation de Master 1. Il est composé des données relatives à 148 pays en 2017 et comprend une variable d'intérêt, l'indice du bonheur; ainsi que 9 variables explicatives :

1) Les dépenses militaires, pourcentage du PIB ;
2) La corruption, indice allant de 0 à 100 ;
3) La mortalité infantile des enfants de moins de 5 ans, taux pour 1000 naissances vivantes ;
4) Le chômage, taux ;
5) Le PIB par habitant, en USD courant ;
6) L'espérance de vie à la naissance ;
7) La pollution atmosphérique aux particules fines (PM2,5), exposition annuelle moyenne (microgrammes par mètre cube) ;
8) Le taux d'utilisateurs d'Internet, pourcentage de la population totale ;
9) Le tourisme, nombre d'arrivées touristiques annuel.


## Le tableau de bord
Nous avons décidé de donner la possibilité à l'utilisateur de choisir entre 4 échantillonnages de notre jeu de données : la base complète, les pays avec un bonheur faible, moyen ou important ("Choisir un echantillon"). Ces classes ont été établies à partir de la valeur des quartiles du Happiness Score. 
Notre dashboard permet une meilleure compréhension des caractéristiques socio-économiques de ces classes via 4 onglets :

1) Le premier onglet regroupe deux graphes. Un Scatter plot, ou nuage de points, dont l'utilisateur peut choisir les axes ("Variable X" et "Variable Y") parmi nos variables afin de se donner une idée de la relation qui existe entre elles. Une boîte à moustache qui permet d'apprécier la variance qui existe au sein de nos déterminants.
2) Le deuxième onglet comprend les statistiques descriptives de l'intégralité de nos données, soit un summary().
3) L'onglet "Table" affiche les données relatives à un nombre de pays à spécifier par l'utilisateur ("Nombre de pays à observer"), pour toutes les variables.
4) Le dernier onglet affiche deux méthodes de clustering : K-means, et DBSCAN. Le nombre de classes de l'approche des K-means est modifiable via le numericInput "Nombre de clusters". Le rayon de voisinage, et le nombre de voisins au sein de ces rayons est modifiable via les sliderInput "Rayon de voisinnage de chaque point" et "Nombre de voisins au sein du rayon". Le dernier plot présent sur cet onglet correspond à un arbre de décision, qui permet d'identifier les variables explicatives les plus importantes pour expliquer les variations du niveau de bonheur au sein de notre échantillon.

Enfin, la base de données d'étude est directement disponible en téléchargement au format .csv via un downloadButton.

 
