library(targets)
library(tarchetypes)
suppressPackageStartupMessages(library(tidyverse))

class_number <- "PMAP 8101"
base_url <- "https://datavizs23.classes.andrewheiss.com/"
page_suffix <- ".html"

options(
  tidyverse.quiet = TRUE,
  dplyr.summarise.inform = FALSE
)

tar_option_set(
  packages = c("tibble"),
  format = "rds",
  workspace_on_error = TRUE
)

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.Rmd).
# There's no way to get a relative path directly out of here::here(), but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}

# Load functions for the pipeline
# source("R/tar_calendar.R")
source("R/tar_data.R")
source("R/tar_slides.R")


# THE MAIN PIPELINE ----
list(
  ## Data saving ----
  save_data,

  ## Class schedule calendar ----
  # tar_target(schedule_file, here_rel("data", "schedule.csv"), format = "file"),
  # tar_target(schedule_page_data, build_schedule_for_page(schedule_file)),
  # tar_target(
  #   schedule_ical_data,
  #   build_ical(
  #     schedule_file, base_url,
  #     page_suffix, class_number
  #   )
  # ),
  # tar_target(
  #   schedule_ical_file,
  #   save_ical(
  #     schedule_ical_data,
  #     here_rel("files", "schedule.ics")
  #   ),
  #   format = "file"
  # ),
  
  
  ## xaringan stuff ----
  #
  ### Knit xaringan slides ----
  #
  # Use dynamic branching to get a list of all .Rmd files in slides/ and knit them
  #
  # The main index.qmd page loads xaringan_slides as a target to link it as a dependency
  tar_files(xaringan_files, list.files(here_rel("slides"),
    pattern = "\\.Rmd",
    full.names = TRUE)),
  tar_target(xaringan_slides,
    render_xaringan(xaringan_files),
    pattern = map(xaringan_files),
    format = "file"),
  
  ### Convert xaringan HTML slides to PDF ----
  #
  # Use dynamic branching to get a list of all knitted slide .html files and
  # convert them to PDF with pagedown
  #
  # The main index.qmd page loads xaringan_pdfs as a target to link it as a dependency
  tar_files(xaringan_html_files, {
    xaringan_slides
    list.files(here_rel("slides"),
      pattern = "\\.html",
      full.names = TRUE)
  }),
  tar_target(xaringan_pdfs,
    xaringan_to_pdf(xaringan_html_files),
    pattern = map(xaringan_html_files),
    format = "file"),
  
  
  ## Knit the README ----
  tar_target(workflow_graph, tar_mermaid(
    targets_only = TRUE, outdated = FALSE,
    legend = FALSE, color = FALSE
  )),
  tar_quarto(readme, here_rel("README.qmd")),
  
  
  ## Build site ----
  tar_quarto(site, path = ".", quiet = FALSE)#,
  
  
  ## Upload site ----
  # tar_target(deploy_script, here_rel("deploy.sh"), format = "file"),
  # tar_target(deploy_site, {
  #   # Force dependencies
  #   site
  #   # Run the deploy script
  #   if (Sys.getenv("UPLOAD_WEBSITES") == "TRUE") {
  #     processx::run(paste0("./", deploy_script))
  #   }
  # })
)
