# **IMDB Movie Analytics Project**

## **Description**

This project analyzes a dataset of movies from IMDB, focusing on the work of legendary directors like **Steven Spielberg**, **George Lucas**, **Martin Scorsese**, **Brian De Palma**, and **Francis Ford Coppola**. The goal is to showcase their influence on the film industry by analyzing key metrics such as adjusted box office gross, number of films directed, genre preferences, and overall contributions across different cinematic eras.

## **Features**
- **Data Cleaning and Preprocessing**: Removal of unnecessary columns, handling missing data, and data type conversions.
- **Financial Analysis**: Inflation-adjusted gross earnings calculated using CPI data.
- **Director Influence**: Comparison of films by the top five directors with others in terms of total earnings, genre preferences, and number of films directed.
- **Era-Based Analysis**: Breakdown of film releases by significant cinematic eras (e.g., The Silent Era, New Hollywood).
- **Visualizations**: Bar charts and line charts comparing key metrics such as the number of films and adjusted gross.

---

## **Getting Started**

### **Prerequisites**
To run this project, you will need:
- **R** (version 4.0 or higher)
- **RStudio** (optional but recommended)
- The following R packages:
  - `tidyverse`
  - `janitor`
  - `skimr`
  - `lubridate`
  - `here`

You can install these packages using the following command:

```r
install.packages(c("tidyverse", "janitor", "skimr", "lubridate", "here"))
