library(styler)
library(cowplot)

# style_dir(here())

source(file.path(here(), "education_and_employment/src/mlid_ee.R"))
source(file.path(here(), "sport/src/mlid_sport.R"))
source(file.path(here(), "international/src/mlid_int.R"))

mlid <- list(
  "ee_1" = produce_ee_overview(),
  "ee_2" = produce_credits_by_dept(),
  "s_1" = produce_sport_overview(),
  "s_2" = produce_football_2023_training(),
  "int_1" = produce_countries_travelled_to(),
  "int_2" = produce_living_overview()
  )


# ee - overview
mlid$ee_1 + cowplot::theme_map()

# ee - modules by dept
mlid$ee_2 + cowplot::theme_minimal_hgrid()

# sport - overview
mlid$s_1

# sport - football (2023)
mlid$s_2 + cowplot::theme_minimal_hgrid()

# int - countries visited
mlid$int_1 + cowplot::theme_minimal_hgrid()

# int - countries lived
mlid$int_2 + cowplot::theme_minimal_hgrid()
