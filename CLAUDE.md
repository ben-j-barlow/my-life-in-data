# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"My Life In Data" — a personal data visualization hobby project. The story of one person's life expressed through data. No tests, no conventional commits.

## Languages and Package Management

- **R** (primary): dependency management via `renv`. Restore with `renv::restore()` in R.
- **Python**: dependency management via Poetry. Install with `poetry install`.

## Running the Visualizations

**R — all visualizations:**
```r
# From R console with working directory set to repo root:
source("main.R")
```

**Python — education wordcloud pipeline:**
```bash
# Scrape module descriptions from the web:
cd education_and_employment/src && poetry run python wc_pull.py

# Generate the wordcloud image:
cd education_and_employment/src && poetry run python wc_visualise_wordcloud.py
```

**Python linting:**
```bash
poetry run black .
poetry run isort .
poetry run flake8 .
```

## Architecture

Each life domain is a self-contained directory with `src/` (scripts) and `data/` (CSVs):

| Domain | Entry point | Visualizations produced |
|---|---|---|
| `sport/` | `sport/src/mlid_sport.R` | Bubble chart of sports history; cumulative area chart of 2023 football training |
| `education_and_employment/` | `education_and_employment/src/mlid_ee.R` (R) + Python scripts | Pie chart of years in education/employment; bar chart of HE credits by dept; word cloud from scraped module pages |
| `international/` | `international/src/mlid_int.R` | Cumulative countries visited over time; stacked bar of where I've lived |
| `podcast/` | `podcast/src/visualise.R` | Stacked bar charts of podcast listening by category per week |

**`main.R`** is the root entry point: it sources all domain `mlid_*.R` files and calls each `produce_*()` function, collecting the returned ggplot objects into a named list.

### Conventions

- R domain entry files are named `mlid_<domain>.R` and source a `visualise_helpers.R` in the same directory.
- All visualization functions are named `produce_<visualization_name>()` and return ggplot2 objects. Themes are applied at the call site in `main.R` (e.g., `+ cowplot::theme_minimal_hgrid()`), not inside the functions.
- Data files with a `c` suffix (e.g., `auditc.csv`, `podcast_directoryc.csv`) are cleaned versions of raw data.
- Python scripts in `education_and_employment/src/` use relative paths via `Path(__file__).parent.parent` to resolve data directories — they must be run from within that directory or with the correct working directory.
- `here::here()` is used in R scripts for all file paths relative to the repo root.
