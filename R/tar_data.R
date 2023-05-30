suppressPackageStartupMessages(library(scales))
library(ggplot2)

# Helpful functions ----

# When using a file-based target, {targets} requires that the function that
# saves the file returns a path to the file. write_csv() invisibly returns the
# data frame being written, so we need a wrapper function to save the file and
# return the path.
save_csv <- function(df, path) {
  readr::write_csv(df, path)
  return(path)
}

# fs::file_copy() returns a path to the copied file, which is nice for
# {targets}. This is a wrapper function to make it so we only need to specify
# the destination folder; the filename of the copied file will remain the same
copy_file <- function(original_file, new_folder) {
  fs::file_copy(path = original_file,
    new_path = fs::path(new_folder, basename(original_file)),
    overwrite = TRUE)
}

# fs::dir_copy() works just like file_copy()
copy_folder <- function(original_folder, new_folder) {
  fs::dir_copy(path = original_folder,
    new_path = fs::path(new_folder, basename(original_folder)),
    overwrite = TRUE)
}


# Pipeline just for generating, saving, and copying data ----
save_data <- list(
  ## Generate or save data ----
  #
  ### Save any data files from packages ----
  # ggplot2::mpg
  tar_target(data_mpg,
    save_csv(ggplot2::mpg,
      here_rel("files", "data", "package_data", "cars.csv")),
    format = "file"),
  
  # gapminder
  tar_target(data_gapminder,
    save_csv(gapminder::gapminder,
      here_rel("files", "data", "package_data", "gapminder.csv")),
    format = "file"),

  
  ### Get data from different APIs ----
  tar_target(get_data_wdi_comparisons, get_wdi_comparisons()),
  tar_target(
    data_wdi_comparisons, 
    save_csv(get_data_wdi_comparisons, 
             here_rel("files", "data", "processed_data", "wdi_comparisons.csv")),
    format = "file"
  ),
  
  tar_target(get_data_wdi_annotations, get_wdi_annotations()),
  tar_target(
    data_wdi_annotations, 
    save_csv(get_data_wdi_annotations, 
             here_rel("files", "data", "processed_data", "wdi_annotations.csv")),
    format = "file"
  ),
  
  tar_target(get_data_wdi_parliament, get_wdi_parliament()),
  tar_target(
    data_wdi_parliament, 
    save_csv(get_data_wdi_parliament, 
      here_rel("files", "data", "processed_data", "wdi_parliament.csv")),
    format = "file"
  ),
  
  tar_target(get_data_fred, get_fred()),
  tar_target(
    data_fred, 
    save_csv(get_data_fred, 
      here_rel("files", "data", "processed_data", "fred.csv")),
    format = "file"
  ),
  
  tar_target(get_data_geocoded, get_geocoded()),
  tar_target(
    data_geocoded, 
    save_csv(get_data_geocoded, 
      here_rel("files", "data", "processed_data", "geocoded.csv")),
    format = "file"
  ),
  
  tar_target(get_data_wdi_lifeexp, get_wdi_lifeexp()),
  tar_target(
    data_wdi_lifeexp, 
    save_csv(get_data_wdi_lifeexp, 
      here_rel("files", "data", "processed_data", "wdi_lifeexp.csv")),
    format = "file"
  ),
  
  tar_target(gutenberg_books, get_gutenberg_books()),
  tar_target(little_women_tagged, tag_little_women(gutenberg_books)),
  tar_target(
    data_little_women_tagged,
    save_csv(little_women_tagged$spacy$token, 
      here_rel("files", "data", "processed_data", "little_women_tagged.csv")),
    format = "file"
  ),
  
  ### Copy files to project folders ----

  # LOTR words spoken via https://github.com/jennybc/lotr-tidy
  tar_target(copy_lotr_fellowship,
    copy_file(here_rel("files", "data", "external_data", "The_Fellowship_Of_The_Ring.csv"),
      new_folder = here_rel("projects", "03-exercise", "data")),
    format = "file"),
  tar_target(copy_lotr_tt,
    copy_file(here_rel("files", "data", "external_data", "The_Two_Towers.csv"),
      new_folder = here_rel("projects", "03-exercise", "data")),
    format = "file"),
  tar_target(copy_lotr_rotk,
    copy_file(here_rel("files", "data", "external_data", "The_Return_Of_The_King.csv"),
      new_folder = here_rel("projects", "03-exercise", "data")),
    format = "file"),
  
  # NYC pandemic-era essential construction via 
  # https://www1.nyc.gov/assets/buildings/html/essential-active-construction.html
  tar_target(copy_essential_construction,
    copy_file(here_rel("files", "data", "external_data", "EssentialConstruction.csv"),
      new_folder = here_rel("projects", "04-exercise", "data")),
    format = "file"),
  
  # Soviet space dogs via https://airtable.com/universe/expG3z2CFykG1dZsp/sovet-space-dogs
  tar_target(copy_space_dogs,
    copy_file(here_rel("files", "data", "external_data", "Dogs-Database.csv"),
      new_folder = here_rel("projects", "05-exercise", "data")),
    format = "file"),
  
  # Election data via https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ
  tar_target(copy_2016_election,
    copy_file(here_rel("files", "data", "external_data", "results_2016.csv"),
      new_folder = here_rel("projects", "07-exercise", "data")),
    format = "file"),
  
  # Data via BLS and collected/processed here
  # https://datavizs23.classes.andrewheiss.com/exercise/08-exercise.html#postscript-how-i-got-this-unemployment-data
  tar_target(copy_unemployment,
    copy_file(here_rel("files", "data", "external_data", "unemployment.csv"),
      new_folder = here_rel("projects", "08-exercise", "data")),
    format = "file"),
  
  # Data via https://ourworldindata.org/internet/
  tar_target(copy_internet,
    copy_file(here_rel("files", "data", "external_data", "share-of-individuals-using-the-internet-1990-2015.csv"),
      new_folder = here_rel("projects", "12-exercise", "data")),
    format = "file"),
  
  # Data via https://www.naturalearthdata.com/downloads/110m-cultural-vectors/
  tar_target(copy_natural_earth,
    copy_folder(here_rel("files", "data", "external_data", "maps", "ne_110m_admin_0_countries"),
      new_folder = here_rel("projects", "12-exercise", "data")),
    format = "file"),
  
  # Data via https://flowingdata.com/2009/07/02/whos-going-to-win-nathans-hot-dog-eating-contest/
  tar_target(copy_hot_dogs,
    copy_file(here_rel("files", "data", "external_data", "hot-dog-contest-winners.csv"),
      new_folder = here_rel("projects", "14-exercise", "data")),
    format = "file")
)


# Data collection functions ----
get_wdi_comparisons <- function() {
  library(WDI)
  
  wdi_raw <- WDI(
    country = "all",
    c(
      life_expectancy = "SP.DYN.LE00.IN",
      access_to_electricity = "EG.ELC.ACCS.ZS",
      co2_emissions = "EN.ATM.CO2E.PC",
      gdp_per_cap = "NY.GDP.PCAP.KD"
    ),
    extra = TRUE,
    start = 1995,
    end = 2015
  )
  
  return(wdi_raw)
}

get_wdi_annotations <- function() {
  library(WDI)
  
  wdi_co2_raw <- WDI(
    country = "all",
    c(
      population = "SP.POP.TOTL",
      co2_emissions = "EN.ATM.CO2E.PC",
      gdp_per_cap = "NY.GDP.PCAP.KD"
    ),
    extra = TRUE,
    start = 1995,
    end = 2015
  )
  
  return(wdi_co2_raw)
}

get_wdi_parliament <- function() {
  library(WDI)
  
  wdi_parl_raw <- WDI(
    country = "all",
    c(
      population = "SP.POP.TOTL",
      prop_women_parl = "SG.GEN.PARL.ZS",
      gdp_per_cap = "NY.GDP.PCAP.KD"
    ),
    extra = TRUE,
    start = 2000,
    end = 2019
  )
  
  return(wdi_parl_raw)
}

get_fred <- function() {
  suppressPackageStartupMessages(library(tidyquant))
  
  fred_raw <- tq_get(
    c(
      "RSXFSN", # Advance retail sales
      "GDPC1", # GDP
      "ICSA", # Initial unemployment claims
      "FPCPITOTLZGUSA", # Inflation
      "UNRATE", # Unemployment rate
      "USREC"
    ), # Recessions
    get = "economic.data", # Use FRED
    from = "1990-01-01"
  )
  
  return(fred_raw)
}

get_geocoded <- function() {
  library(tidygeocoder)
  
  geocoded_addresses <- tibble::tribble(
    ~name,             ~address,
    "The White House", "1600 Pennsylvania Ave NW, Washington, DC",
    "The Andrew Young School of Policy Studies", "55 Park Place SE, Atlanta, GA 30303"
  ) |>
    geocode(address, method = "census")
  
  return(geocoded_addresses)
}

get_wdi_lifeexp <- function() {
  library(WDI)
  
  wdi_lifeexp_raw <- WDI(
    country = "all",
    c(life_expectancy = "SP.DYN.LE00.IN"),
    extra = TRUE,
    start = 2015,
    end = 2015
  )
  
  return(wdi_lifeexp_raw)
}

get_gutenberg_books <- function() {
  library(gutenbergr)
  
  # 514 Little Women
  little_women_raw <- gutenberg_download(
    514,
    meta_fields = "title",
    mirror = "http://aleph.gutenberg.org"
  )

  # 1524 - Hamlet
  # 1532 - King Lear
  # 1533 - Macbeth
  # 1513 - Romeo and Juliet
  tragedies_raw <- gutenberg_download(
    c(1524, 1532, 1533, 1513),
    meta_fields = "title",
    mirror = "http://aleph.gutenberg.org"
  )
  
  return(tibble::lst(little_women_raw, tragedies_raw))
}

tag_little_women <- function(raw_text) {
  library(tidyverse)
  library(cleanNLP)
  
  little_women <- raw_text$little_women_raw %>% 
    # The actual book doesn't start until line 67
    slice(67:n()) %>% 
    # Get rid of rows where text is missing
    drop_na(text) %>% 
    # Chapters start with CHAPTER X, so mark if each row is a chapter start
    # cumsum() calculates the cumulative sum, so it'll increase every time there's
    # a new chapter and automatically make chapter numbers
    mutate(chapter_start = str_detect(text, "^CHAPTER"),
      chapter_number = cumsum(chapter_start)) %>% 
    # Get rid of these columns
    select(-gutenberg_id, -title, -chapter_start)
  
  little_women_to_tag <- little_women %>% 
    # Group by chapter number
    group_by(chapter_number) %>% 
    # Take all the rows in each chapter and collapse them into a single cell
    nest(data = c(text)) %>% 
    ungroup() %>% 
    # Look at each individual cell full of text lines and paste them together into
    # one really long string of text per chapter
    mutate(text = map_chr(data, ~paste(.$text, collapse = " "))) %>% 
    # Get rid of this column
    select(-data)
  
  # Use the built-in R-based tagger
  cnlp_init_udpipe()
  udpipe <- cnlp_annotate(little_women_to_tag, 
    text_name = "text", 
    doc_name = "chapter_number")
  
  # Use spaCy
  # In theory it should be possible to install spacy and cleannlp in a
  # virtualenv through reticulate and then run it from here in R/Quarto, but
  # cnlp_init_spacy() can't see it for some reason, either because there's a bug
  # in it (not likely) or because I have something configured wrong, like in the
  # RETICULATE_PYTHON environment variable (super likely). So for now, we have
  # to manually install things with `pip3 install cleannlp` and all the other
  # pip things necessary for spaCy
  cnlp_init_spacy("en_core_web_sm")
  spacy <- cnlp_annotate(little_women_to_tag, 
    text_name = "text", 
    doc_name = "chapter_number")
  
  return(lst(udpipe, spacy))
}
