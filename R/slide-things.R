slide_buttons <- function(slide_id) {
  glue::glue('<p class="buttons"><a class="btn btn-danger" target="_blank" href="{slide_id}.html"><i class="fa-solid fa-arrow-up-right-from-square"></i> View all slides in new window</a> <a class="btn btn-danger" target="_blank" href="{slide_id}.pdf" role="button"><i class="fa-solid fa-file-pdf"></i> Download PDF of all slides</a></p>')
}
