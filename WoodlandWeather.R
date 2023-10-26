### WoodlandWeather
## Joseph D. Webb - October 2023
## A open source program used to match lattitude and longitude to New England forests
## For instructions to use refer to the ReadMe at github.io/josephdwebb/ForestMatch

### Necessary Libraries
library(rvest)
library(ggplot2)
library(geosphere) #install.packages("geosphere") #See instructions for downlading geosphere
## ------------------------------ Work Space -----------------------------------
## Global Variables
### The name of the site you are searching for
sitename = "Agnew State Forest"
site_latitude = 40
site_longitude = -75

## Date of Interest
month = 03
year = 2021

### Station Matching Conditions 
number_of_stations = 3

### Disclaimer: To search by specific variable range view "SiteData.csv".
## -----------------------------------------------------------------------------
## ---------------------------- Function Code ----------------------------------
## Install(): Start of Function Code
install <- function()  
## Prerequisite: Check if station data is installed 
  if (!dir.exists("station_data_temp")) {
    dir.create("station_data_temp")

    ### Defining variables for download (WARNING: Changing may break code)
    noaa_url <- "https://www.ncei.noaa.gov/data/global-summary-of-the-month/access/"
    stationid_vector <- read.csv("assets/StationID.csv", header = FALSE, skip = 1)$V1
    download_time <- format(Sys.Date(), format = "%d %B %Y")

    ### Download monthly data report of all US stations. (Approximately 65,000 stations)
    start_time <- Sys.time()  # Record download start time
    downloaded_stations <- 0  # Define an empty variable count

    for (stationid in stationid_vector) {
      file_url <- paste0(noaa_url, stationid)
      download_dir <- "station_data_temp"
      download_path <- file.path(download_dir, stationid)
      
      # Check if the file already exists
      if (!file.exists(download_path)) {
        download.file(file_url, destfile = download_path, method = "auto")
        downloaded_stations <- downloaded_stations + 1
      } else {
        cat(paste("File already exists:", stationid, "\n"))
      }
    }

    end_time <- Sys.time()  # Record the end time
    download_duration <- end_time - start_time # equation to calculate download duration

    cat(paste("Download complete. Downloaded", downloaded_stations, "Stations in", as.numeric(download_duration, units = "mins"), "minutes.\n"))

  } else {
    # Bypass Station Download if folder located
    cat(paste("Station_Data_Temp Folder located.\n"))
  
  # Initialize user_input to start the loop
  user_input <- ""

  # Start a loop to keep asking the question until valid input is provided
    while (tolower(user_input) != "yes" && tolower(user_input) != "no") {
    user_input <- readline(prompt = "Would you like to update station_data_temp? (yes/no): ")
    
    if (tolower(user_input) == "yes") {
      cat("Deleting station_data_temp\n")

      # Your code to generate the output table goes here
    } else if (tolower(user_input) != "yes") {
      break
    }
  }
}
}




## Woodlandweather(): Start of Function Code
woodlandweather <- function() {
## Prerequisite: Check if station data is installed 
  if (!dir.exists("station_data_temp")) {
    dir.create("station_data_temp")

    ### Defining variables for download (WARNING: Changing may break code)
    noaa_url <- "https://www.ncei.noaa.gov/data/global-summary-of-the-month/access/"
    stationid_vector <- read.csv("assets/StationID.csv", header = FALSE, skip = 1)$V1
    download_time <- format(Sys.Date(), format = "%d %B %Y")

    ### Download monthly data report of all US stations. (Approximately 65,000 stations)
    start_time <- Sys.time()  # Record download start time
    downloaded_stations <- 0  # Define an empty variable count

    for (stationid in stationid_vector) {
      file_url <- paste0(noaa_url, stationid)
      download_dir <- "station_data_temp"
      download_path <- file.path(download_dir, stationid)
      
      # Check if the file already exists
      if (!file.exists(download_path)) {
        download.file(file_url, destfile = download_path, method = "auto")
        downloaded_stations <- downloaded_stations + 1
      } else {
        cat(paste("File already exists:", stationid, "\n"))
      }
    }

    end_time <- Sys.time()  # Record the end time
    download_duration <- end_time - start_time # equation to calculate download duration

    cat(paste("Download complete. Downloaded", downloaded_stations, "Stations in", as.numeric(download_duration, units = "mins"), "minutes.\n"))

  } else {
    # Bypass Station Download if folder located
    cat("-----------------------------------------------------------------\
                  WoodlandWeather - Version 1.0.3\
-----------------------------------------------------------------\
Background:\n")
    cat(paste("> Station_Data_Temp located.\n"))
  }
 
## Step 1 of 3: Combine all individual files to create USStationData
  # Define the list of required variables; will define columns in USStationData
  required_variables <- c("STATION","DATE","LATITUDE","LONGITUDE","ELEVATION","NAME","DP01",
                          "DP10","DP1X","DSND","DSNW","DYSD","DYSN","DYXP",
                          "EMSD","EMSN","EMXP","PRCP","SNOW")

  if (!exists("USStationData")) {
    # Define an empty data frame with the required columns
    USStationData <- data.frame(matrix(NA, nrow = 0, ncol = length(required_variables)))
    colnames(USStationData) <- required_variables

    station_files <- list.files("station_data_temp", full.names = TRUE, pattern = "\\.csv$") # List CSV files

    # Loop through each CSV file and append its data to USStationData
    for (station_file in station_files) {
      # Read the CSV file
      data <- read.csv(station_file, header = TRUE, stringsAsFactors = FALSE)
      
      # Ensure that the data frame has all the required columns
      for (var in required_variables) {
        if (!(var %in% colnames(data))) {
          data[var] <- NA
        }
      }

      # Reorder columns to match the required_variables order
      data <- data[, required_variables]
      
      # Append the data to USStationData
      USStationData <- rbind(USStationData, data)
      
      cat(station_file, "appended to USStationData.\n")
    }

  } else {
    cat("> USStationData located.\n")
  }

## Step 2 of 3: Filtering USStatonData by month and year
  StationData <- subset(USStationData, 
                    as.integer(substring(DATE, 1, 4)) == year & 
                    as.integer(substring(DATE, 6, 7)) == month)


## Step 3 of 3: Matching desired coordinate to closest station(s), reorder by distance, add variable counts
    StationData$"DISTANCE(KM)" <- distHaversine(
    matrix(c(site_longitude, site_latitude), ncol = 2), # Convert the site coordinates to a matrix
    matrix(c(StationData$LONGITUDE, StationData$LATITUDE), ncol = 2) # Create a matrix of data coordinates
  )

  # Calculate the number of non-NA values for each row
  columns_to_exclude <- c("STATION", "DATE", "LATITUDE", "LONGITUDE", "ELEVATION", "NAME")
  non_na_counts <- apply(StationData[, setdiff(required_variables, columns_to_exclude)], 1, function(row) sum(!is.na(row)))

  # Create a new column in the data frame with the non-NA counts
  StationData$"#VARIABLES" <- non_na_counts

  ## Reordering the Rows by Distance
  StationData <- StationData[order(StationData$"DISTANCE(KM)"), ]

  ## Crop by the number of desired stations
  StationData <- StationData[1:number_of_stations, ]

  # Output Summary Table
  summary_data <- StationData[, c("STATION", "DATE", "LATITUDE", "LONGITUDE", "DISTANCE(KM)", "#VARIABLES")]
  cat("-----------------------------------------------------------------\
                            Summary Table\
-----------------------------------------------------------------\n")
  print(summary_data)
  cat("-----------------------------------------------------------------\n")

# Initialize user_input to start the loop
  user_input <- ""

# Start a loop to keep asking the question until valid input is provided
  while (tolower(user_input) != "yes" && tolower(user_input) != "no") {
  user_input <- readline(prompt = "Would you like to view the variables for the identified station(s)? (yes/no): ")
  
  if (tolower(user_input) == "yes") {
    cat("Generating output table...\n")
    # Your code to generate the output table goes here
  } else if (tolower(user_input) != "yes") {
    break
  }
}
}
## Step 4 of 4: Generating Output Table





## -----------------------------------------------------------------------------
## -------------------------- Execute Function ---------------------------------

woodlandweather()