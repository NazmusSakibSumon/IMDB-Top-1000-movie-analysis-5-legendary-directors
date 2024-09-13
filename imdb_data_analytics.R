# ------------------- IMDB Movie Analysis: 5 Legendary Directors -------------------
# This project analyzes movies from IMDB, focusing on the influence of 5 legendary directors.
# Data includes movie titles, directors, gross earnings, and CPI data for inflation adjustment.
# -------------------------------------------------------------------------------

# ------------------------ Setup Environment -------------------------------------

# Load necessary libraries
library(tidyverse)   # For data manipulation and visualization
library(janitor)     # For quick data cleaning functions
library(skimr)       # For data exploration and summary
library(lubridate)   # For date manipulation
library(here)        # For working directories and file paths
library(tidyr)

# ------------------------ Load Data ---------------------------------------------

# Public URLs to the datasets hosted on GitHub
imdb_url <- "https://raw.githubusercontent.com/NazmusSakibSumon/IMDB-Top-1000-movie-analysis-5-legendary-directors/main/imdb.csv"
cpi_url <- "https://raw.githubusercontent.com/NazmusSakibSumon/IMDB-Top-1000-movie-analysis-5-legendary-directors/main/cpi.csv"

# Load the datasets from the public URLs
imdb <- read_csv(imdb_url)
cpi_data <- read_csv(cpi_url)

# Preview the data
glimpse(imdb)
glimpse(cpi_data)

# --------------------- Initial Data Exploration & Cleaning ----------------------

# Quick summary of the datasets
skim(imdb)
skim(cpi_data)

# Remove unnecessary columns: 'Poster_Link' and 'Overview'
imdb_cleaned <- imdb %>%
  select(-Poster_Link, -Overview)

# Handle missing values
colSums(is.na(imdb_cleaned))

# Extract only the numeric part of the 'Runtime' column (convert from "142 min" to "142")
imdb_cleaned <- imdb_cleaned %>%
  mutate(Runtime = parse_number(Runtime))

# Convert 'Released_Year' to integer
imdb_cleaned <- imdb_cleaned %>%
  mutate(Released_Year = as.integer(Released_Year))

# Rename 'Series_Title' to 'Movie'
imdb_cleaned <- imdb_cleaned %>%
  rename(Movie = Series_Title)

# ------------------------ Inflation Adjustment ----------------------------------

# Perform a left join to add CPI data to imdb_cleaned based on Released_Year
imdb_cleaned <- imdb_cleaned %>%
  left_join(cpi_data, by = c("Released_Year" = "Year"))

# Assume the reference CPI is 2020 (latest year)
reference_cpi <- 258.811

# Calculate adjusted gross by inflating values to 2020 CPI
imdb_cleaned <- imdb_cleaned %>%
  mutate(adjusted_gross = Gross / Avg_cpi * reference_cpi)

# Convert adjusted_gross to millions and round to 2 decimal places
imdb_cleaned <- imdb_cleaned %>%
  mutate(adjusted_gross = round(adjusted_gross / 1e6, 2))

# --------------------- Data Analytics -------------------------------------------

# 1. Top 10 Years with the Highest Number of Movies
top_years <- imdb_cleaned %>%
  group_by(Released_Year) %>%
  summarise(movie_count = n()) %>%
  arrange(desc(movie_count)) %>%
  slice_head(n = 10)

ggplot(top_years, aes(x = reorder(Released_Year, -movie_count), y = movie_count)) +
  geom_bar(stat = "identity", fill = "steelblue", color = "black") +
  labs(title = "Top 10 Years with Highest Number of Movies", x = "Released Year", y = "Number of Movies") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 2. Top 10 Genres
# Create a temporary dataset by separating multiple genres into individual rows
temp_dataset <- imdb_cleaned %>%
  select(Movie, Director, Genre) %>%
  separate_rows(Genre, sep = ", ")

top_genres <- temp_dataset %>%
  group_by(Genre) %>%
  summarise(movie_count = n()) %>%
  arrange(desc(movie_count)) %>%
  slice_head(n = 10)

ggplot(top_genres, aes(x = reorder(Genre, -movie_count), y = movie_count)) +
  geom_bar(stat = "identity", fill = "steelblue", color = "black") +
  labs(title = "Top 10 Genres with Highest Number of Movies", x = "Genre", y = "Number of Movies") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 3. Top 10 Directors by Number of Movies
top_directors <- imdb_cleaned %>%
  group_by(Director) %>%
  summarise(
    movie_count = n(),
    total_adjusted_gross = sum(adjusted_gross, na.rm = TRUE),
    average_adjusted_gross = mean(adjusted_gross, na.rm = TRUE)
  ) %>%
  arrange(desc(movie_count)) %>%
  slice_head(n = 10)

ggplot(top_directors, aes(x = reorder(Director, -movie_count), y = movie_count)) +
  geom_bar(stat = "identity", fill = "steelblue", color = "black") +
  labs(title = "Top 10 Directors by Number of Movies", x = "Director", y = "Number of Movies") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4. Selected Directors' Stats (Steven Spielberg, George Lucas, etc.)
directors_list <- c("Steven Spielberg", "George Lucas", "Martin Scorsese", "Brian De Palma", "Francis Ford Coppola")

director_stats <- imdb_cleaned %>%
  filter(Director %in% directors_list) %>%
  group_by(Director) %>%
  summarise(
    count_of_movies = n(),
    total_adjusted_gross = sum(adjusted_gross, na.rm = TRUE),
    average_adjusted_gross = mean(adjusted_gross, na.rm = TRUE)
  )

print(director_stats)

# 5. Other Top Directors
other_directors <- imdb_cleaned %>%
  filter(!Director %in% directors_list) %>%
  group_by(Director) %>%
  summarise(
    count_of_movies = n(),
    total_adjusted_gross = sum(adjusted_gross, na.rm = TRUE),
    average_adjusted_gross = mean(adjusted_gross, na.rm = TRUE)
  ) %>%
  arrange(desc(count_of_movies)) %>%
  slice_head(n = 10)

print(other_directors)

# ------------------------ Director Genre Analysis --------------------------------

# Find the most common genre for each selected director
genre_stats <- temp_dataset %>%
  filter(Director %in% directors_list) %>%
  group_by(Director, Genre) %>%
  summarise(count = n()) %>%
  mutate(total = sum(count), percentage = (count / total) * 100) %>%
  arrange(Director, desc(percentage))

most_common_genre <- genre_stats %>%
  group_by(Director) %>%
  slice_max(percentage, with_ties = TRUE)

print(most_common_genre)

# ------------------------ Era-Based Analysis ------------------------------------

# Define the eras based on 'Released_Year'
imdb_cleaned <- imdb_cleaned %>%
  mutate(era = case_when(
    Released_Year >= 1920 & Released_Year <= 1929 ~ "The Silent Era (1920-1929)",
    Released_Year >= 1930 & Released_Year <= 1949 ~ "The Golden Age of Hollywood (1930-1949)",
    Released_Year >= 1950 & Released_Year <= 1969 ~ "Post-War and Decline of Studio System (1950-1969)",
    Released_Year >= 1970 & Released_Year <= 1989 ~ "New Hollywood and Blockbuster Era (1970-1989)",
    Released_Year >= 1990 & Released_Year <= 2009 ~ "Digital and Franchise Era (1990-2009)",
    Released_Year >= 2010 & Released_Year <= 2020 ~ "Streaming and Global Cinema (2010-2020)",
    TRUE ~ "Unknown Era"
  ))

# Group by era and calculate movie stats
era_movie_stats <- imdb_cleaned %>%
  group_by(era) %>%
  summarise(
    movie_count = n(),
    average_adjusted_gross = mean(adjusted_gross, na.rm = TRUE),
    directors_movie_count = sum(Director %in% directors_list)
  ) %>%
  arrange(desc(movie_count))

print(era_movie_stats)

# ------------------------ Top 10 Movies by Directors ----------------------------

# 1. Top 10 Movies by Directors in 'directors_list'
top_movies_by_list_directors <- imdb_cleaned %>%
  filter(Director %in% directors_list) %>%
  select(Movie, Director, adjusted_gross) %>%
  arrange(desc(adjusted_gross)) %>%
  slice_head(n = 10)

print(top_movies_by_list_directors)

# 2. Top 10 Movies by Other Directors
top_movies_by_other_directors <- imdb_cleaned %>%
  filter(!Director %in% directors_list) %>%
  select(Movie, Director
         