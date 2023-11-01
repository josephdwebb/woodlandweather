## WoodlandWeather - Config 
## Define paramters for customizing woodlandweather() output

# Graphic elements for Header
Header <-   ("--------------------------------------------------------------------------\
                  WoodlandWeather - Version 1.1.0
--------------------------------------------------------------------------\n")

# Graphc eleent for Divider
Divider <- ("--------------------------------------------------------------------------\n")

# Export the variables for other files to use
assign("Divider", Divider, envir=.GlobalEnv)
assign("Header", Header, envir=.GlobalEnv)


# Help Function
help <- function() {
cat(Header)
cat(
"Welcome to WoodlandWeather, an open-source weather data retrieval tool.
For more information,  visit: josephdwebb.com/projects/woodlandweather/

Usage: woodlandweather [arguments]

Required Arguments:
  s=        site         Specify the site name for data retrieval.
  lat=      latitude     Specify the latitude of the site.
  long=     longitude    Specify the longitude of the site.
  m=        month        Specify the month for data retrieval (MM).
  y=        year         Specify the year for data retrieval (YYYY).
  n=        number       Specify the number of stations to retrieve.

Example:
Retrieve weather data for Agnew State Forest in June 2022:
woodlandweather(s=\"Centennial\", lat= 44, long= -73, m= 06m y= 2022 n= 3)

Feel free to contribute on GitHub: github.com/josephdwebb/woodlandweather.
For support and feedback, please contact Joe at josephwebb4@hotmail.com
--------------------------------------------------------------------------\n")
}

