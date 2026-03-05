library(data.table)
library(lubridate)
library(ggplot2)
library(tidyverse)
library(stringr)
library(here)

source(file.path(here(), "international/src/visualise_helpers.R"))

produce_countries_travelled_to <- function() {
  my_data <- fread(file.path(here(), "international/data/countries.csv"))
  my_data <- my_data[!is.na(year)]
  my_data$year <- character_to_yyyy(my_data$year)
  my_data$year <- my_data$year + 1
  
  data_pivot <- my_data[, .(countries_visited = uniqueN(country), 
                            country_list = list(unique(country))),
                        by = .(year)]
  
  data_pivot <- my_data[, .(countries_visited = uniqueN(country),
                            country_list = list(unique(country))),
                        by = .(year)]
  
  data_pivot$country_list <- sapply(data_pivot$country_list, function(x) paste(x, collapse = "\n"))
  
  data_pivot <- data_pivot %>%
    complete(year = 1999:year(today()), fill = list(countries_visited = 0 , country_list = ""))
  
  data_pivot$label_position <- cumsum(data_pivot$countries_visited) + 2.5
  
  return(ggplot(data_pivot, aes(x = year, y = cumsum(countries_visited))) +
    geom_line() +
    geom_point() +
    geom_text(aes(label = country_list, x = year, y = label_position), hjust = 1, vjust = 1, nudge_x = -1, nudge_y = -2.3, size = 1.5) +
    labs(title = "Total Number of Countries Visited (by Year)",
         x = "Year",
         y = "Total Countries Visited"))
}

produce_living_overview <- function() {
  my_data <- fread(file.path(here(), "international/data/living.csv"))
  my_data$date <- dmy(my_data$date)
  setnames(my_data, "date", "arrive")
  
  my_data[, leave := shift(my_data$arrive, type = "lead", fill = today())]
  my_data[, total_days := as.integer(leave - arrive)]
  
  specific_countries <- c("Scotland", "England", "France", "Spain")
  my_data$country_grouped <- ifelse(my_data$country %in% specific_countries, my_data$country, "Other")
  my_data$country_grouped <- factor(my_data$country_grouped, levels = c(specific_countries, "Other"))
  
  return(ggplot(my_data, aes(x = country_grouped, y = total_days, fill = status)) +
    stat_summary(geom = "bar", fun = "sum", position = "stack") +
    labs(title = "Where Have I Lived? (by Country and Status)",
         subtitle = paste0("1st Jan 2022 - ", get_today_for_subtitle()),
         x = "Country",
         y = "Days") +
    scale_fill_discrete(name = "Living Status", labels = str_to_title))
}