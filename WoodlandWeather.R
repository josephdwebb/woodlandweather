### WoodlandWeather
## Joseph D. Webb - October 2023
## A open source program used to match lattitude and longitude to New England forests
## For instructions to use refer to the ReadMe at github.io/josephdwebb/ForestMatch

### Necessary Libraries
library(rvest)

## ------------------------------ Work Space -----------------------------------
## Global Variables
### The name of the site you are searching for
sitename = "Agnew State Forest"
site_latitude = 40
site_longitude = -75

### Station Matching Conditions 
min_station_distance = 0 #kilometers
max_station_distance = 10 #kilometers
number_of_stations = 3

## Date of Interest
month = 06
year = 2022

### Disclaimer: To search by specific variable range view "SiteData.csv".
## -----------------------------------------------------------------------------
## ---------------------------- Function Code ----------------------------------
## Start of function code
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

    cat(paste("Download complete. Downloaded", downloaded_stations, "Stations in", as.numeric(download_duration, units = "secs"), "seconds.\n"))

  } else {
    # Bypass Station Download if folder located
    cat(paste("Station_Data Folder located.\n"))
  }
 
## Step 1 of 3: Creating USStationData, combining all individual files.
  if (!exists("USStationData")) {
    ### Defining variables for compilation 
    USStationData <- data.frame() # Define an empty data frame
    station_files <- list.files("station_data_temp", full.names = TRUE) # List all CSV files in the directory

    # Loop through each CSV file and append its data to USStationData
      for (station_file in station_files) {
        # Read the CSV file
        data <- read.csv(station_file, header = TRUE, stringsAsFactors = FALSE)
      
          # Append the data to USStationData
          USStationData <- rbind(USStationData, data)

        cat("USStationData Dataframe updated.\n")
      }

  } else {
    cat("USStationData located.\n")
  }
  
}

## Step 2 of 3: Filtering USStatonData by month and year
  StationData <- subset(USStationData, 
                    as.integer(substring(DATE, 1, 4)) == year & 
                    as.integer(substring(DATE, 6, 7)) == month)

## Step 3 of 3: Matching desired coordinate to closest station(s)


## Step 4 of 4: Generating Output Table




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
  
  
  