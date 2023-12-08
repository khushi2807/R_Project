# R_Project
![1](https://github.com/khushi2807/R_Project/assets/109760268/777ea941-06f9-445f-b043-cc140e4d9c6c)

# Crop Recommendation App

![App Screenshot](https://github.com/khushi2807/R_Project/assets/109760268/ee522e4b-825f-4a7c-85d8-1ab1ad3cf3fd)

## Overview

This Shiny web application provides a crop recommendation based on input parameters such as Nitrogen, Phosphorous, Potassium, Temperature, Humidity, pH, and Rainfall. The app utilizes a decision tree model trained on a dataset to predict the most suitable crop for the given conditions.

## Features

- Prediction: Enter parameter values and click the "Predict Crop" button to get a prediction.
- Average Parameter Levels: Visualize average parameter levels for each crop with an interactive bar chart.
- Crop Distribution: Explore the distribution of crops in a 3D scatter plot.
- Sample Data: View a DataTable displaying a subset of the dataset.
- Parameter Graphs: Access detailed plots for Nitrogen, Phosphorous, Potassium, Temperature, Humidity, pH, and Rainfall levels for each crop.

## Screenshots

<img src="https://github.com/khushi2807/R_Project/assets/109760268/c05f9e97-db43-426f-8aca-3eb55faa5024" width="400">

<img src="https://github.com/khushi2807/R_Project/assets/109760268/7be15047-86fb-4890-b255-d5600a0de6f8" width="450">

<img src="https://github.com/khushi2807/R_Project/assets/109760268/0e7eeeec-071a-4c7a-ac24-564b99bdc721" width="400">

<img src="https://github.com/khushi2807/R_Project/assets/109760268/c1270d27-b8c7-4452-a4e1-1bc6eef6e131" width="500">

<img src="https://github.com/khushi2807/R_Project/assets/109760268/85050fd9-954a-4cd8-bc74-e5618db9b89f" width="450">




## Getting Started

### Prerequisites

- [R](https://www.r-project.org/) (version 4.3.2 )
- [Shiny](https://shiny.rstudio.com/) (version 1.8.0)
- [Caret](https://topepo.github.io/caret/index.html) (version 6.0-94)
- [Rpart](https://cran.r-project.org/web/packages/rpart/index.html) (version 4.1.23)
- [Shinyjs](https://cran.r-project.org/web/packages/shinyjs/index.html) (version 2.1.0)
- [Shinydashboard](https://cran.r-project.org/web/packages/shinydashboard/index.html) (version 0.7.2)
- [Plotly](https://plotly.com/r/) (version 5.18.0)
- ...

### Installation

1. Clone the repository:

      git clone https://github.com/khushi2807/crop-recommendation-app.git
   

2. Install required R packages:

      install.packages(c("shiny", "caret", "rpart", "shinyjs", "shinydashboard", "plotly"))
   

### Usage

1. Navigate to the project directory:

      cd crop-recommendation-app
   

2. Run the Shiny app:

      runApp("app.R")
   

3. Access the app in your web browser at http://127.0.0.1:port/ (replace port with the port number displayed in the R console).

## Contributors

- [Khushi Jain](https://github.com/khushi2807)
- [Manogya Jain](https://github.com/ManogyaJain02)



## Acknowledgments

- Special thanks to Professor [Sumit Kumar] for their invaluable guidance, mentorship, and motivation throughout the development of this project. Their expertise and support greatly contributed to the successful completion of the Crop Recommendation App.

---


