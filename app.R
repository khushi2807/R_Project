# Load required libraries
library(shiny)
library(caret)
library(rpart)
library(shinyjs)
library(shinydashboard)
library(plotly)

# Read the dataset
df <- read.csv("Crop_recommendation.csv")

# Assuming 'label' is your target variable
df$label <- as.factor(df$label)

# Define server
server <- function(input, output) {
  # Reactive values for holding prediction result, label_numeric, and average parameter levels
  result <- reactiveValues(prediction = NULL, label_numeric = NULL, avg_param_levels = NULL)
  
  observeEvent(input$predictBtn, {
    # Create a decision tree model
    crop_model <- rpart(label ~ N + P + K + temperature + humidity + ph + rainfall, data = df, method = "class")
    
    # Function to make predictions
    new_data <- data.frame(
      N = input$N,
      P = input$P,
      K = input$K,
      temperature = input$temperature,
      humidity = input$humidity,
      ph = input$ph,
      rainfall = input$rainfall
    )
    
    prediction <- predict(crop_model, new_data, type = "class")
    result$prediction <- paste("Predicted Crop: ", prediction)
    
    # Extract label_numeric for 3D scatter plot
    result$label_numeric <- df[, c("N", "P", "K", "label")]
    
    # Calculate average parameter levels for each crop
    avg_param_levels <- aggregate(. ~ label, df, mean)
    result$avg_param_levels <- avg_param_levels[, c("label", "N", "P", "K", "temperature", "humidity", "ph", "rainfall")]
  })
  
  # Output the predicted crop
  output$prediction <- renderText({
    result$prediction
  })
  
  # Bar chart to show average parameter levels for each crop
  output$averageBarChart <- renderPlotly({
    if (!is.null(result$avg_param_levels)) {
      plot_ly(result$avg_param_levels, x = ~label, y = ~N, type = "bar", name = "Nitrogen", marker = list(color = "#1f77b4")) %>%
        add_trace(y = ~P, name = "Phosphorous", marker = list(color = "#ff7f0e")) %>%
        add_trace(y = ~K, name = "Potassium", marker = list(color = "#2ca02c")) %>%
        add_trace(y = ~temperature, name = "Temperature", marker = list(color = "#d62728")) %>%
        add_trace(y = ~humidity, name = "Humidity", marker = list(color = "#9467bd")) %>%
        add_trace(y = ~ph, name = "pH", marker = list(color = "#8c564b")) %>%
        add_trace(y = ~rainfall, name = "Rainfall", marker = list(color = "#e377c2")) %>%
        layout(title = "Average Parameter Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Average Level"))
    }
  })
  
  # 3D Scatter plot to show distribution of crops
  output$scatterPlot <- renderPlotly({
    if (!is.null(result$label_numeric)) {
      # Create a 3D scatter plot using plot_ly
      plot_ly(data = result$label_numeric, x = ~N, y = ~P, z = ~K, color = ~label, type = "scatter3d", mode = "markers") %>%
        layout(scene = list(xaxis = list(title = "Nitrogen"), yaxis = list(title = "Phosphorous"), zaxis = list(title = "Potassium")))
    }
  })
  
  # DataTable to show sample data
  output$sampleData <- renderDataTable({
    head(df, 100)
  })
  
  # Output plots for each parameter in the new tab
  output$nitrogenPlot <- renderPlotly({
    plot_ly(df, x = ~label, y = ~N, type = "bar", name = "Nitrogen", marker = list(color = "#1f77b4")) %>%
      layout(title = "Nitrogen Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Nitrogen Level"))
  })
  
  output$phosphorousPlot <- renderPlotly({
    plot_ly(df, x = ~label, y = ~P, type = "bar", name = "Phosphorous", marker = list(color = "#ff7f0e")) %>%
      layout(title = "Phosphorous Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Phosphorous Level"))
  })
  
  output$potassiumPlot <- renderPlotly({
    plot_ly(df, x = ~label, y = ~K, type = "bar", name = "Potassium", marker = list(color = "#2ca02c")) %>%
      layout(title = "Potassium Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Potassium Level"))
  })
  
  output$temperaturePlot <- renderPlotly({plot_ly(df, x = ~label, y = ~temperature, type = "bar", name = "Temperature", marker = list(color = "#d62728")) %>%
      layout(title = "Temperature Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Temperature"))
  })
  
  output$humidityPlot <- renderPlotly({
    plot_ly(df, x = ~label, y = ~humidity, type = "bar", name = "Humidity", marker = list(color = "#9467bd")) %>%
      layout(title = "Humidity Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Humidity"))
  })
  
  output$phPlot <- renderPlotly({
    plot_ly(df, x = ~label, y = ~ph, type = "bar", name = "pH", marker = list(color = "#8c564b")) %>%
      layout(title = "pH Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "pH"))
  })
  
  output$rainfallPlot <- renderPlotly({
    plot_ly(df, x = ~label, y = ~rainfall, type = "bar", name = "Rainfall", marker = list(color = "#e377c2")) %>%
      layout(title = "Rainfall Levels for Each Crop", xaxis = list(title = "Crop"), yaxis = list(title = "Rainfall"))
  })
}

# Define UI using shinydashboard
ui <- navbarPage(
  "Crop Recommendation App",
  tabPanel("Home",
           dashboardPage(
             dashboardHeader(title = "Crop Recommendation App"),
             dashboardSidebar(
               # Input widgets for user to provide values
               numericInput("N", "Nitrogen", value = 50),
               numericInput("P", "Phosphorous", value = 30),
               numericInput("K", "Potassium", value = 20),
               numericInput("temperature", "Temperature", value = 25),
               numericInput("humidity", "Humidity", value = 60),
               numericInput("ph", "pH", value = 7),
               numericInput("rainfall", "Rainfall", value = 100),
               actionButton("predictBtn", "Predict Crop")
             ),
             dashboardBody(
               tags$style(HTML("
      body {
        background-image: url('https://images.nationalgeographic.org/image/upload/t_edhub_resource_key_image/v1638892233/EducationHub/photos/crops-growing-in-thailand.jpg');
        background-size: cover;
        background-repeat: no-repeat;
        background-attachment: fixed;
      }
    ")),
               # Output to display the predicted crop
               box(
                 title = "Prediction",
                 solidHeader = TRUE,
                 status = "primary",
                 textOutput("prediction"),
                 width = 8
               ),
               
               # Bar chart to show average parameter levels for each crop
               box(
                 title = "Average Parameter Levels",
                 solidHeader = TRUE,
                 status = "warning",
                 plotlyOutput("averageBarChart"),
                 width = 6
               ),
               
               # 3D Scatter plot to show distribution of crops
               box(
                 title = "Crop Distribution",
                 solidHeader = TRUE,
                 status = "info",
                 plotlyOutput("scatterPlot"),
                 width = 6
               ),
               
               # DataTable to show sample data
               box(
                 title = "Sample Data",
                 solidHeader = TRUE,
                 status = "success",
                 dataTableOutput("sampleData"),
                 width = 12
               )
             )
           )
  ),
  tabPanel("Parameter Graphs",
           fluidPage(
             # Placeholder for the content of the new page
             box(
               title = "Nitrogen Levels for Each Crop",
               solidHeader = TRUE,
               status = "primary",
               plotlyOutput("nitrogenPlot")
             ),
             box(
               title = "Phosphorous Levels for Each Crop",
               solidHeader = TRUE,
               status = "primary",
               plotlyOutput("phosphorousPlot")
             ),
             box(
               title = "Potassium Levels for Each Crop",
               solidHeader = TRUE,status = "primary",
               plotlyOutput("potassiumPlot")
             ),
             box(
               title = "Temperature Levels for Each Crop",
               solidHeader = TRUE,
               status = "primary",
               plotlyOutput("temperaturePlot")
             ),
             box(
               title = "Humidity Levels for Each Crop",
               solidHeader = TRUE,
               status = "primary",
               plotlyOutput("humidityPlot")
             ),
             box(
               title = "pH Levels for Each Crop",
               solidHeader = TRUE,
               status = "primary",
               plotlyOutput("phPlot")
             ),
             box(
               title = "Rainfall Levels for Each Crop",
               solidHeader = TRUE,
               status = "primary",
               plotlyOutput("rainfallPlot")
             )
           )
  )
)

# Run the Shiny app
shinyApp(ui = ui, server = server)
