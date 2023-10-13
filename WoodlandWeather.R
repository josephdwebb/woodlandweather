### WoodlandWeather
## Joseph D. Webb - October 2023
## A open source program used to match lattitude and longitude to New England forests
## For instructions to use refer to the ReadMe at github.io/josephdwebb/ForestMatch

## ------------------------------ Work Space -----------------------------------
## Global Variables
### The name of the site you are searching for
sitename = "Agnew_State_Forest"
site_latitude =
site_longitude =

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
## -------------------------- Execute Function ---------------------------------

## -----------------------------------------------------------------------------

## ---------------------------- Function Code ----------------------------------
  
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
  
  
  