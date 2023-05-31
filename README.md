
<!-- README.md is generated from README.qmd. Please edit that file -->

# Data Visualization with R <a href='https://econs23.classes.andrewheiss.com/'><img src='files/favicon-512.png' align="right" height="139" /></a>

[PMAP 8101 • Summer 2023](https://datavizs23.classes.andrewheiss.com/)  
[Andrew Heiss](https://www.andrewheiss.com/) • Andrew Young School of
Policy Studies • Georgia State University

------------------------------------------------------------------------

**[Quarto](https://quarto.org/) +
[{targets}](https://docs.ropensci.org/targets/) +
[{renv}](https://rstudio.github.io/renv/) = magic! 🪄**

------------------------------------------------------------------------

## How to build the site

1.  Install
    [RStudio](https://www.rstudio.com/products/rstudio/download/#download)
    version 2022.07.1 or later since it has a
    [Quarto](https://quarto.org/) installation embedded in it.
    Otherwise, download and install [Quarto](https://quarto.org/)
    separately.
2.  Open `datavizs23.Rproj` to open an [RStudio
    Project](https://r4ds.had.co.nz/workflow-projects.html).
3.  If it’s not installed already, R *should* try to install the [{renv}
    package](https://rstudio.github.io/renv/) when you open the RStudio
    Project for the first time. If you don’t see a message about package
    installation, install it yourself by running
    `install.packages("renv")` in the R console.
4.  Run `renv::restore()` in the R console to install all the required
    packages for this project.
5.  Run `targets::tar_make()` in the R console to build everything.
6.  🎉 All done! 🎉 The complete website will be in a folder named
    `_site/`.

## {targets} pipeline

I use the [{targets} package](https://docs.ropensci.org/targets/) to
build this site and all its supporting files. The complete pipeline is
defined in [`_targets.R`](_targets.R) and can be run in the R console
with:

``` r
targets::tar_make()
```

The pipeline does several major tasks:

- **Build Quarto website**: This project is a [Quarto
  website](https://quarto.org/docs/websites/), which compiles and
  stitches together all the `.qmd` files in this project based on the
  settings in [`_quarto.yml`](_quarto.yml). See the [Quarto website
  documentation](https://quarto.org/docs/websites/) for more details.

- **Upload resulting `_site/` folder to my remote server**: Quarto
  places the compiled website in a folder named `/_site/`. The pipeline
  uses `rsync` to upload this folder to my personal remote server. This
  target will only run if the `UPLOAD_WEBSITES` environment variable is
  set to `TRUE`, and it will only work if you have an SSH key set up on
  my personal server, which only I do.

The complete pipeline looks like this:

<small>(This uses [`mermaid.js`
syntax](https://mermaid-js.github.io/mermaid/) and should display as a
graph on GitHub. You can also view it by pasting the code into
<https://mermaid.live>.)</small>

``` mermaid
graph LR
  subgraph Graph
    direction LR
    x584558a723e721e8(["get_data_wdi_parliament"]):::queued --> x6257a071b04552ec(["data_wdi_parliament"]):::queued
    xe264aed1d24b2666(["copy_2016_election"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    xcccbbdda9cfb9efa(["copy_essential_construction"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    x53fd41efa5307134(["copy_hot_dogs"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    x7749e303ca970c8f(["copy_internet"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    xfa60d0b3d647f7be(["copy_lotr_fellowship"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    xb2006b3b1bd6d066(["copy_lotr_rotk"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    x7f607a819d79efcc(["copy_lotr_tt"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    x6127fce3de0dfbf7(["copy_natural_earth"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    x1b8b8e8d8af57455(["copy_space_dogs"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    x3558dd4715a45865(["copy_unemployment"]):::queued --> x41092a7251862a9e(["copy_data"]):::queued
    xb4844be3dca7f02b(["project_paths"]):::queued --> x7a8b235bff1bfb75["project_files"]:::queued
    xdf832f8e1f99baf2(["schedule_file"]):::queued --> x35552a73efe9c59f(["schedule_ical_data"]):::queued
    x1c33983abaf4aaf6(["get_data_wdi_comparisons"]):::queued --> x4c7791641b8d2bb8(["data_wdi_comparisons"]):::queued
    x9c20b8c56debbe9a(["deploy_script"]):::queued --> x78f3e0b711425f1c(["deploy_site"]):::queued
    x7aa56383a054e8ba(["site"]):::queued --> x78f3e0b711425f1c(["deploy_site"]):::queued
    x8561012c918af7bc(["gutenberg_books"]):::queued --> xfe165dffeddf6d72(["little_women_tagged"]):::queued
    x4a210bdf90796bca(["xaringan_files_files"]):::queued --> xf4774655f169db90["xaringan_files"]:::queued
    xb453b5ae08dcaee7(["build_data"]):::queued --> x1917c787a0a4a0fd["project_zips"]:::queued
    x41092a7251862a9e(["copy_data"]):::queued --> x1917c787a0a4a0fd["project_zips"]:::queued
    x7a8b235bff1bfb75["project_files"]:::queued --> x1917c787a0a4a0fd["project_zips"]:::queued
    x4de216039f7bf4b5(["data_fred"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x2826b69a7ed43365(["data_geocoded"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x5665e562725fbc7c(["data_little_women_tagged"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    xdc2ee1f91a48eea8(["data_wdi_annotations"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x4c7791641b8d2bb8(["data_wdi_comparisons"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x65944038b6e536cc(["data_wdi_lifeexp"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x6257a071b04552ec(["data_wdi_parliament"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x8561012c918af7bc(["gutenberg_books"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    xfe165dffeddf6d72(["little_women_tagged"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x1917c787a0a4a0fd["project_zips"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    x4d31f5a49d5ae49f(["schedule_ical_file"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x063edd335cc1b36f(["schedule_page_data"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    xccbb2c85646c611a["xaringan_pdfs"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    x60c212b45249134a["xaringan_slides"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    x9b008e6053f9b5db(["get_data_geocoded"]):::queued --> x2826b69a7ed43365(["data_geocoded"]):::queued
    xa48826fcb4dc2e34(["project_paths_change"]):::queued --> xb4844be3dca7f02b(["project_paths"]):::queued
    xf38d3f5e6365ad72(["workflow_graph"]):::queued --> x6e52cb0f1668cc22(["readme"]):::queued
    x0751853b619def05["xaringan_html_files"]:::queued --> xccbb2c85646c611a["xaringan_pdfs"]:::queued
    xdf832f8e1f99baf2(["schedule_file"]):::queued --> x063edd335cc1b36f(["schedule_page_data"]):::queued
    x4de216039f7bf4b5(["data_fred"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x8288901d8e9e8d55(["data_gapminder"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x2826b69a7ed43365(["data_geocoded"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x5665e562725fbc7c(["data_little_women_tagged"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x182180f03bcfc8dc(["data_mpg"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    xdc2ee1f91a48eea8(["data_wdi_annotations"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x4c7791641b8d2bb8(["data_wdi_comparisons"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x65944038b6e536cc(["data_wdi_lifeexp"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x6257a071b04552ec(["data_wdi_parliament"]):::queued --> xb453b5ae08dcaee7(["build_data"]):::queued
    x5561075885186d22(["get_data_wdi_annotations"]):::queued --> xdc2ee1f91a48eea8(["data_wdi_annotations"]):::queued
    xfe165dffeddf6d72(["little_women_tagged"]):::queued --> x5665e562725fbc7c(["data_little_women_tagged"]):::queued
    xf4774655f169db90["xaringan_files"]:::queued --> x60c212b45249134a["xaringan_slides"]:::queued
    x7a0d40becb063bda(["xaringan_html_files_files"]):::queued --> x0751853b619def05["xaringan_html_files"]:::queued
    x2b2b802bd276c544(["get_data_fred"]):::queued --> x4de216039f7bf4b5(["data_fred"]):::queued
    x9785b2e8d32c03fd(["get_data_wdi_lifeexp"]):::queued --> x65944038b6e536cc(["data_wdi_lifeexp"]):::queued
    x35552a73efe9c59f(["schedule_ical_data"]):::queued --> x4d31f5a49d5ae49f(["schedule_ical_file"]):::queued
    x60c212b45249134a["xaringan_slides"]:::queued --> x7a0d40becb063bda(["xaringan_html_files_files"]):::queued
  end
```

## Fonts and colors

The fonts used throughout the site are [Fira Sans
Condensed](https://fonts.google.com/specimen/Fira+Sans+Condensed) and
[Barlow](https://fonts.google.com/specimen/Barlow).

The colors for the site and hex logo come from the
[plasma](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html#the-color-scales)
color scale from the viridis color maps:

``` r
viridisLite::viridis(8, option = "plasma", begin = 0.1, end = 0.9)
```

<img src="README_files/figure-commonmark/show-plasma-1.png"
width="768" />

## Licenses

**Text and figures:** All prose and images are licensed under Creative
Commons ([CC-BY-NC
4.0](https://creativecommons.org/licenses/by-nc/4.0/))

**Code:** All code is licensed under the [MIT License](LICENSE.md).
