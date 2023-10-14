### WoodlandWeather
## Joseph D. Webb - October 2023
## A open source program used to match lattitude and longitude to New England forests
## For instructions to use refer to the ReadMe at github.io/josephdwebb/ForestMatch

### Necessary Libraries
library(rvest)

## ------------------------------ Work Space -----------------------------------
## Global Variables
### The name of the site you are searching for
sitename = "Agnew_State_Forest"
site_latitude = 40
site_longitude = -75

### Station Matching Conditions 
min_station_distance = 0 #kilometers
max_station_distance = 10 #kilometers
number_of_stations = 3

## Date of Interest
month = 06
year = 2022

### PCA
peform_PCA = TRUE
  dp01 = TRUE
  dp10 = TRUE
  dp35 = TRUE 
  dp70 = TRUE 
  CLDD = TRUE
  ...
graph_PCA: FALSE

### Disclaimer: To search by specific variable range view "StationData.csv".
## -----------------------------------------------------------------------------
## ---------------------------- Function Code ----------------------------------
## Start of function code
woodlandweather <- function() {
  data_folder <- "station_data_temp"  ## Name of the temporary data folder
  
  # Check if the data folder exists
  if (!dir.exists(data_folder)) {
    # If it doesn't exist, create the folder and download the files
    dir.create(data_folder)
    
    # Define the URL of the NOAA Weather Station Monthly Reports
    noaa_data_url <- "https://www.ncei.noaa.gov/data/global-summary-of-the-month/access/"
    
    # Function to download and save a file
    download_and_save_file <- function(url, folder) {
      filename <- basename(url)
      destination <- file.path(folder, filename)
      download.file(url, destfile = destination, mode = "wb")
    }
    
    # Fetch the webpage and extract links to CSV files
    page <- read_html(noaa_data_url)
    links <- page %>%
      html_nodes("a[href^='US'][href$='.csv']") %>%
      html_attr("href")
    
    # Download and save each CSV file
    for (link in links) {
      full_url <- paste0(noaa_data_url, link)
      download_and_save_file(full_url, data_folder)
    }
    
    cat("station_data_temp created and files downloaded.\n")
  } else {
    cat("station_data_temp found.\n")
  }
}




## -----------------------------------------------------------------------------
## -------------------------- Execute Function ---------------------------------

woodlandweather()





  


  ## Output:
  
  ## Print:
  ##    (2) Stations Found. Generating summary table...
  #3    (0) Stations Found. Widen search parameters. 
  
  ## Agnew_State_Forest | 40.123, -72.445 | Data Reported for May, 2023
  ## ------------------------------------------------------------------
  ##  1 | Station Name | Distance | Variables.... |  Var_Count | 
  ##  2 | Station Name | Distance | Variables.... |  Var_Count | 
  ##  3 | Station Name | Distance | Variables.... |  Var_Count | 
  ## ------------------------------------------------------------------
  ## PCA: -0.23, PCA R^2: 0.64 
  
  
  