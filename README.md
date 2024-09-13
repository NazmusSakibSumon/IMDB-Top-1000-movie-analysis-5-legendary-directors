IMDB Movie Analytics Project
Description
This project analyzes a dataset of movies from IMDB, focusing on the work of legendary directors like Steven Spielberg, George Lucas, Martin Scorsese, Brian De Palma, and Francis Ford Coppola. The goal is to showcase their influence on the film industry by analyzing key metrics such as adjusted box office gross, number of films directed, genre preferences, and overall contributions across different cinematic eras.

Features
Data Cleaning and Preprocessing: Removal of unnecessary columns, handling missing data, and data type conversions.
Financial Analysis: Inflation-adjusted gross earnings calculated using CPI data.
Director Influence: Comparison of films by the top five directors with others in terms of total earnings, genre preferences, and number of films directed.
Era-Based Analysis: Breakdown of film releases by significant cinematic eras (e.g., The Silent Era, New Hollywood).
Visualizations: Bar charts and line charts comparing key metrics such as the number of films and adjusted gross.
Getting Started
Prerequisites
To run this project, you will need:

R (version 4.0 or higher)
RStudio (optional but recommended)
The following R packages:
tidyverse
janitor
skimr
lubridate
here
You can install these packages using the following command:

r
Copy code
install.packages(c("tidyverse", "janitor", "skimr", "lubridate", "here"))
Datasets
This project uses two main datasets:

IMDB Dataset: A collection of movies including fields such as title, director, release year, genre, IMDB rating, and gross.
CPI Dataset: Consumer Price Index data for adjusting movie gross earnings for inflation.
Both datasets are available in this repository under the data/ folder.

Running the Analysis
Clone this repository to your local machine:

bash
Copy code
git clone https://github.com/your-username/imdb-movie-analytics.git
cd imdb-movie-analytics
Open the R script file (imdb_movie_analysis.R) in RStudio or your preferred R environment.

The IMDB and CPI datasets are automatically loaded from the repository. If you'd like to use your own data, replace the dataset URLs in the script.

Run the script to generate the visualizations and summary tables.

Example R Code Snippet
r
Copy code
# Load the datasets from public URLs
imdb_url <- "https://raw.githubusercontent.com/your-username/your-repo/main/imdb.csv"
cpi_url <- "https://raw.githubusercontent.com/your-username/your-repo/main/cpi.csv"

imdb <- read_csv(imdb_url)
cpi_data <- read_csv(cpi_url)

# View the data
glimpse(imdb)
glimpse(cpi_data)
Visualizations
The analysis includes visualizations such as:

Bar charts comparing the number of movies directed by top directors.
Line charts showing the financial impact of movies across different cinematic eras.
Contributing
If you’d like to contribute to this project, feel free to fork the repository and submit a pull request with your improvements.

License
This project is licensed under the MIT License. See the LICENSE file for more details.

Project Overview
Repository: [Your GitHub Repository Link]
Maintainer: Your Name
Contact: Your Email
