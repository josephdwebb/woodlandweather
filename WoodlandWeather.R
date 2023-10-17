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

### Disclaimer: To search by specific variable range view "StationData.csv".
## -----------------------------------------------------------------------------
## ---------------------------- Function Code ----------------------------------
## Start of function code
woodlandweather <- function() {

  # Check to see if station data is installed 
  if (!dir.exists("station_data_temp")) {

    dir.create("station_data_temp")

    ## Generate List of Unique Appearances in CLOSE_STAT ##
    unique_stations <- unique(forest_data$CLOSE_STAT)

    # Set the URL for the csv files
    url <- "https://www.ncei.noaa.gov/data/global-summary-of-the-month/access/"

      # Loop through the station IDs and download the corresponding csv file
      for (station_id in forest_data$CLOSE_STAT) {
        if (startsWith(station_id, "US")) {
          file_url <- paste0(url, station_id, ".csv")
          download.file(file_url, destfile = paste0("StatData/", station_id, ".csv"), method = "curl")
        }
      }

      ### Create new matrix that combines the station data for May 2022
      ## find used varaibles
      # Set the path to the directory containing the CSV files
      path <- "station_data_temp"

      # Get a list of all the CSV files in the directory
      files <- list.files(path, pattern = ".csv$")

      # Initialize an empty data frame to store the frequency counts
      freq_table <- data.frame(variable = character(),
                              count = numeric(),
                              stringsAsFactors = FALSE)

      # Loop through the CSV files
      for (file in files) {
        # Read in the data from the current file
        data <- read.csv(file.path(path, file), stringsAsFactors = FALSE)
        
        # Get the column names
        col_names <- names(data)
        
        # Remove Station, Date, Latitude, Longitude, and Name columns
        col_names <- col_names[!col_names %in% c("STATION", "DATE", "LATITUDE", "LONGITUDE", "NAME")]
        
        # Loop through the remaining columns
        for (col_name in col_names) {
          # Check if the variable is already in the frequency table
          if (col_name %in% freq_table$variable) {
            # Increment the count for the variable
            freq_table[freq_table$variable == col_name, "count"] <- freq_table[freq_table$variable == col_name, "count"] + 1
      } else {
        # Add a new row to the frequency table for the variable
        freq_table <- rbind(freq_table, data.frame(variable = col_name, count = 1, stringsAsFactors = FALSE))
      }
    }
  }

  freq_table <- subset(freq_table, !grepl("ATTRIBUTES$", variable))

  # Print the frequency table (45 variables)
  print(freq_table)
    } else {
      cat("station_data_temp found.\n")
    }
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
  
  
  