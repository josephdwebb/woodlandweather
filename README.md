# Woodlandweather
WoodlandWeather is an open-source program designed to match US latitude and longitude coordinates to NCEI monthly weather reports. This document provides a comprehensive guide on how to use the code, from downloading the required data to running the main function.

## Required Library: Geosphere
The primary purpose of this program is to rank the distance between two geospatial coordinates according to the 'haversine method'. This method assumes a spherical earth, ignoring ellipsoidal effects. The R-package [geosphere](https://cran.r-project.org/web/packages/geosphere/geosphere.pdf) is installed to make this calculation. 

To install **geosphere** run:
`install.packages("geosphere")`

## Installation

Before you can run the `woodlandweather()` program, you will need to follow these steps, which includes downloading the NCEI monthly weather reports. This process may take up to 8 hours and will require approximately 5GB of space on your device as it downloads data from over 70,000 weather stations. Please read the following instructions carefully:

### Step 1: Making a Pull Request

1. Visit [WoodlandWeather](https://github.com/josephdwebb/woodlandweather) if you don't have the repository, you can clone it to your local machine.
2. To make a Pull Request, fork the repository to your own GitHub account.
3. Clone your forked repository to your local machine using Git or GitHub Desktop.

### Step 2: Opening the Program

1. Open your preferred R environment, such as RStudio or VisualStudioCode.
2. In your R environment, navigate to the `WoodlandWeather.R` file within your local clone of the repository.
3. Open the `WoodlandWeather.R` file.

### Step 3: Running the Program

1. Select the entire code in the `WoodlandWeather.R` file by pressing `Ctrl + A` (Windows/Linux) or `Cmd + A` (Mac) to highlight everything.
2. Run the selected code by pressing `Ctrl + Enter` (Windows/Linux) or `Cmd + Enter` (Mac). This will run the program and log the variables and functions.

### Step 4: Running `install()`

1. After the `WoodlandWeather` program completes, you will be ready to use it. However, you need to download station data first. To do this, execute the `install()` function.

```R
install()
```
This step will begin the data download process. As mentioned before, it will require about 5GB of space and up to 8 hours to complete. The code will output a confirmation message when the installation is finished, at which point you can proceed to use woodlandweather[options] for data retrieval.

When the installation is complete the terminal will output a similar message:

<p align="center">
  <img src="/assets/images/Install_Complete.png" width="528" height="97">
</p>

Please ensure that you have enough disk space and time to complete the installation as any interruption will require a fresh install.

## Using WoodlandWeather
The `woodlandweather` function is used to retrieve weather data for a specified site. The required arguments are:
| Required Argument | Description                    |
|-------------------|--------------------------------|
| s                 | Site name                      |
| lat               | Latitude of the site           |
| long              | Longitude of the site          |
| m                 | Month (MM) for data retrieval  |
| y                 | Year (YYYY) for data retrieval |
| n                 | Number of stations to retrieve |

**Example**:
```R
woodlandweather(s = "Centennial", lat = 44, long = -73, m = 06, y = 2022, n = 3)
```
This function will retrieve NCEI weather station data for the desired time period, reorder the stations by distance, and export a summary table. You can choose to export the variables for the identified station(s) as a CSV file.

## Sample Output
<p align="center">
  <img src="/assets/images/Woodlandweather_Output.png" width="607" height="299">
</p>

As seen above, the input `woodlandweather(s = "Centennial", lat = 44, long = -73, m = 06, y = 2022, n = 3)` matched the site to the five closest stations in the subset. By replying `yes` to the question, a summary csv is generated and output to `/output/` with the name `s_m-y.csv`.

## Help
To get assistance or view usage instructions, you can use the `help()` function:
This will provide information on required arguments and general usage.

For more information and updates, please visit the [GitHub Page](https://github.com/josephdwebb/woodlandweather) and feel free to contribute or contact Joseph at josephwebb4@hotmail.com for support and feedback.

