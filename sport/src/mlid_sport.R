library(ggplot2)
library(lubridate)
library(here)
library(tidyverse)

source(file.path(here(), "sport/src/visualise_helpers.R"))

visualize <- function(audit, y_unit = "hr", color_dict = get_colors()) {
  switch(y_unit,
         "hr" = {
           mult <<- 1 / 60
         },
         "min" = {
           mult <<- 1
         },
         default = {
           mult <<- 1
         }
  )
  
  audit <- audit %>%
    # mutate(week = floor_date(date, unit = "week")) %>%
    arrange(date) %>%
    group_by(type) %>%
    mutate(cumulative_duration = cumsum(duration))
  
  return(ggplot(audit, aes(x = date, y = cumulative_duration * mult, fill = type)) +
           geom_area() +
           scale_fill_manual(values = color_dict) +
           scale_x_date(date_breaks = "2 week", date_labels = "%b %d", limits = c(as.Date("2023-01-23"), max(audit$date))) +
           xlab("date") +
           ylab("total duration / hours") + 
           labs(fill = "exercise type"))
}


get_colors <- function() {
  return(c(
    "gym" = "#FFD700",             # Gold
    "gym (with PT)" = "#FFA500",   # Orange
    "match" = "#8C564B",           # Coral
    "pitch (individual)" = "#00BFFF",   # Deep Sky Blue
    "pitch (team)" = "#008080",    # Teal
    "yoga" = "#FF5733"             # Dark Orange
  ))
}

produce_football_2023_training <- function() {
  audit <- read_audit()
  audit <- clean_audit(audit)
  audit <- fill_missing_data(audit)
  return(visualize(audit))
}


produce_sport_overview <- function() {
  history <- data.table(
    sport = c("Football", "Golf", "Cricket", "Table Tennis", "Tennis", "X Country", "Rugby"),
    years_played = c(18, 4, 6, 3, 1, 2, 3)
  )
  history <- rbind(history, data.table(sport = c("Skiing"), years_played = calculate_years_skied(history = history)))
  
  # Generate the layout. This function return a dataframe with one line per bubble. 
  # It gives its center (x and y) and its radius, proportional of the value
  packing <- circleProgressiveLayout(history$years_played, sizetype='area')
  
  # We can add these packing information to the initial data frame
  history <- cbind(history, packing)
  
  # The next step is to go from one center + a radius to the coordinates of a circle that
  # is drawn by a multitude of straight lines.
  dat.gg <- circleLayoutVertices(packing, npoints=50)
  
  # Make the plot
  return(ggplot() + 
           # Make the bubbles
           geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)), colour = "black", alpha = 0.6) +
           
           # Add text in the center of each bubble + control its size
           geom_label(data = history, mapping = aes(x, y, label = sport), label.size = history$years_played * 0.05) +
           scale_size_continuous(range = c(1,4)) +
           
           # General theme:
           theme_void() + 
           theme(legend.position="none") +
           coord_equal())
}

