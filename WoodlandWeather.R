### WoodlandWeather
## Joseph D. Webb - October 2023
## A open source program used to match lattitude and longitude to New England forests
## For instructions to use refer to the ReadMe at github.io/josephdwebb/ForestMatch

### Necessary Libraries
library(geosphere) #install.packages("geosphere") #See instructions for downloading geosphere
## ------------------------------ Work Space -----------------------------------

# Example use of code
# install()
woodlandweather(s= "Centennial", lat= 40, long= -75, m= 07, y= 2022, n= 10)

## ---------------------------- Function Code ----------------------------------
## Install(): Start of Function Code
install <- function(download_subset = 0) {
  # Step 1 of 4: Load the graphic variables from config.R
  source("assets/config.R")

  # Step 2 of 4: Determine state of station_data_temp
  if (!dir.exists("station_data_temp")) {
    dir.create("station_data_temp")

    if (download_subset <= 0) {
    cat("Downloading all US stations...\n")
      } else {
    cat(paste("Downloading", download_subset, "stations...\n"))
      }

    # Defining variables for download
    noaa_url <- "https://www.ncei.noaa.gov/data/global-summary-of-the-month/access/"
    station_id_file <- "assets/StationID.csv"
    station_id_data <- read.csv(station_id_file, header = FALSE, skip = 1)$V1
    download_time <- format(Sys.Date(), format = "%d %B %Y")

    # Determine the range of stations to download based on the argument
    if (download_subset > 0) {
      stationid_vector <- station_id_data[1:download_subset]
    } else {
      stationid_vector <- station_id_data
    }

    # Download station data
    start_time <- Sys.time()
    downloaded_stations <- 0

    for (stationid in stationid_vector) {
      file_url <- paste0(noaa_url, stationid)
      download_dir <- "station_data_temp"
      download_path <- file.path(download_dir, stationid)

      if (!file.exists(download_path)) {
        download.file(file_url, destfile = download_path, method = "auto")
        downloaded_stations <- downloaded_stations + 1
      } else {
        cat(paste("File already exists:", stationid, "\n"))
      }
    }

    end_time <- Sys.time()
    download_duration <- end_time - start_time

    # Calculate the download duration in seconds
    duration_seconds <- as.numeric(download_duration, units = "secs")

    # Calculate the download duration in minutes
    duration_minutes <- duration_seconds / 60

    # Calculate the download duration in hours
    duration_hours <- duration_minutes / 60

    cat(Header)
    if (duration_hours >= 1) {
      cat("> Download complete. Downloaded", downloaded_stations, "Stations in",
          sprintf("%.1f", duration_hours), "hours.\n")
    } else if (duration_minutes >= 1) {
      cat("> Download complete. Downloaded", downloaded_stations, "Stations in",
          sprintf("%.1f", duration_minutes), "minutes.\n")
    } else {
      cat("> Download complete. Downloaded", downloaded_stations, "Stations in",
          sprintf("%.1f", duration_seconds), "seconds.\n")
    }

    cat("\n> Please proceed to `woodlandweather()` for data retrieval.\n")
    cat(Divider)

    if (exists("USStationData", envir = .GlobalEnv)) { #Remove USStationData for datanalysis
      rm(USStationData, envir = .GlobalEnv)
    }

  } else {
    # Bypass Station Download if folder is located
    cat(Header)
    cat(paste("> Station_Data_Temp is already installed.\n\n"))

    # Initialize user_input to start the loop
    user_input <- ""

    while (tolower(user_input) != "yes" && tolower(user_input) != "no") {
      user_input <- readline(prompt = "Would you like to update station_data_temp? (yes/no): ")

      ## If user wants to update their folder
      if (tolower(user_input) == "yes") {
        cat("Deleting station_data_temp\n")
        # Delete the station_data_temp folder
        unlink("station_data_temp", recursive = TRUE)
        dir.create("station_data_temp")

        # Re-read station_id_data
        noaa_url <- "https://www.ncei.noaa.gov/data/global-summary-of-the-month/access/"
        station_id_file <- "assets/StationID.csv"
        station_id_data <- read.csv(station_id_file, header = FALSE, skip = 1)$V1

        # Download station data (download_subset) stations
        start_time <- Sys.time()
        downloaded_stations <- 0

        for (stationid in station_id_data[1:download_subset]) {
          file_url <- paste0(noaa_url, stationid)
          download_dir <- "station_data_temp"
          download_path <- file.path(download_dir, stationid)

          if (!file.exists(download_path)) {
            download.file(file_url, destfile = download_path, method = "auto")
            downloaded_stations <- downloaded_stations + 1
          } else {
            cat(paste("File already exists:", stationid, "\n"))
          }
        }

        end_time <- Sys.time()
        download_duration <- end_time - start_time

        # Calculate the download duration in seconds
        duration_seconds <- as.numeric(download_duration, units = "secs")

        # Calculate the download duration in minutes
        duration_minutes <- duration_seconds / 60

        # Calculate the download duration in hours
        duration_hours <- duration_minutes / 60

        cat(Header)
        if (duration_hours >= 1) {
          cat("> Download complete. Downloaded", downloaded_stations, "Stations in",
              sprintf("%.1f", duration_hours), "hours.\n")
        } else if (duration_minutes >= 1) {
          cat("> Download complete. Downloaded", downloaded_stations, "Stations in",
              sprintf("%.1f", duration_minutes), "minutes.\n")
        } else {
          cat("> Download complete. Downloaded", downloaded_stations, "Stations in",
              sprintf("%.1f", duration_seconds), "seconds.\n")
        }

        cat("\n> Please proceed to `woodlandweather()` for data retrieval.\n")
        cat(Divider)

        if (exists("USStationData", envir = .GlobalEnv)) { #Remove USStationData for WoodlandWeather
          rm(USStationData, envir = .GlobalEnv)
        }

        ## if user does not want to update station_data_temp
      } else if (tolower(user_input) != "yes") {
        cat(Divider)
        cat("> Installation aborted.\n> Please proceed to `woodlandweather()` for data retrieval.\n")
        cat(Divider)
        break
      }
    }
  }
}


## Woodlandweather(): Start of Function Code
woodlandweather <- function(s = NULL, lat = NULL, long = NULL, m = NULL, y = NULL, n = NULL, h= NULL) {
  
  cat("\n\n\n") # Defiine break from terminal input
  cat(Header) # Define start of function output
  
  ## Prerequisites
  ## Step 1 of 3: Detect Necessary Packages
  required_packages <- c("geosphere")

  if (!all(sapply(required_packages, function(pkg) requireNamespace(pkg, quietly = TRUE)))) {
    install_prompt <- readline("Error: Necessary packages not installed. Would you like to install them? (yes/no): ")

    if (tolower(install_prompt) == "yes") {
      install.packages(required_packages)
      cat("> Installed necessary packages:", paste(required_packages, collapse = ", "), "\n")
    } else {
      cat("> Aborting the data retrieval process.\n")
      cat("> Please ensure that all necessary packages are installed to proceed.\n")
      cat("> If you need assistance with package installation, refer to the provided documentation.\n")
      cat(Divider)
      return()
    }
  } else {
    cat("> Required libraries are already installed.\n")
  }

# Step 2 of 3: Check for Missing Required Argument(s)
  if (is.null(s) || is.null(lat) || is.null(long) || is.null(m) || is.null(y) || is.null(n)) {
    cat("\nError: Missing required option(s). Please provide all required options.\n")
    cat("Type `help()` for help regarding required arguments.\n")
    cat(Divider)
    return()
  }
  
## Step 3 of 3: Assess State of StationData
  if (!dir.exists("station_data_temp")) {
    cat("\nError: Station data not found. \nPlease execute 'install()' to download the required data.\n")
    cat(Divider)
    return()
  } else {
    cat(paste("> Station_Data_Temp located.\n"))
  }
 
## Data Retrieval
## Step 1 of 3: Combine all individual files to create USStationData
  # Define the list of required variables; will define columns in USStationData
  required_variables <- c("STATION", "DATE", "LATITUDE", "LONGITUDE",
                   "ELEVATION", "NAME", "CDSD", "CLDD", "DP01",
                   "DP10", "DP1X", "DSND", "DT00", "DT32", "DX32",
                   "DX70", "DX90", "DYNT", "DYSD", "DYXP", "DYXT",
                   "EMNT", "EMSD", "EMXP", "EMXT", "HDSD", "HTDD",
                   "PRCP", "TAVG", "TMAX", "TMIN", "DSNW", "DYSN",
                   "EMSN", "SNOW")

  if (!exists("USStationData")) {
    # Define an empty data frame with the required columns
    USStationData <- data.frame(matrix(NA, nrow = 0, ncol = length(required_variables)))
    colnames(USStationData) <- required_variables

    station_files <- list.files("station_data_temp", full.names = TRUE, pattern = "\\.csv$") # List CSV files

    # Create a progress bar
    pb <- txtProgressBar(min = 0, max = length(station_files), style = 3)

    # Loop through each CSV file and append its data to USStationData
    for (i in 1:length(station_files)) {
      station_file <- station_files[i]
      
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
      
      # Update the progress bar
      setTxtProgressBar(pb, i)
    }

    # Close the progress bar
    close(pb)

    cat("\nData from all stations appended to USStationData.\n")
    assign("USStationData", USStationData, envir = .GlobalEnv)
  } else {
    cat("> USStationData located.\n")
  }

## Step 2 of 3: Filtering USStatonData by month and year
  StationData <- subset(USStationData, 
                    as.integer(substring(DATE, 1, 4)) == y & 
                    as.integer(substring(DATE, 6, 7)) == m)

  if (nrow(StationData) == 0) {
    cat(Divider)
    cat("Error: No data is available for the specified year and month. \nPlease consider selecting a different time period for analysis.")
    cat(Divider)
    return()
  } else {

## Step 3 of 3: Matching desired coordinate to closest station(s), reorder by distance, add variable counts
    StationData$"DISTANCE(KM)" <- distHaversine(
    matrix(c(long, lat), ncol = 2), # Convert the site coordinates to a matrix
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
  StationData <- StationData[1:n, ]

  # Output Summary Table
    summary_data <- StationData[, c("STATION", "DATE", "LATITUDE", "LONGITUDE", "DISTANCE(KM)", "#VARIABLES")]
    cat("--------------------------------------------------------------------------\
                              Summary Table\
--------------------------------------------------------------------------\n")
    print(summary_data)
    cat(Divider)
  }

  # Initialize user_input to start the loop
  user_input <- ""

  # Start a loop to keep asking the question until valid input is provided
  while (tolower(user_input) != "yes" && tolower(user_input) != "no") {
    user_input <- readline(prompt = "Would you like to export the variables for the identified station(s)? (yes/no): ")

    if (tolower(user_input) == "yes") {
      cat("Generating output table...\n")

      # Check if the "output" folder exists, and create it if not
      if (!dir.exists("output")) {
        dir.create("output")
      }

      # Define the output CSV file name
      output_file_name <- paste0(
        gsub(" ", "_", s),
        "_", sprintf("%02d", m), "-", y,
        ".csv"
      )

      # Save StationData as a CSV in the "output" folder
      output_file_path <- file.path("output", output_file_name)
      write.csv(StationData, file = output_file_path, row.names = FALSE)
      
      cat("Output saved as:", output_file_path, "\n")
    } else {
      cat("No output requested.\n")
      break
    }
  }
}

