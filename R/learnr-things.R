embedded_learnr <- function(url, id) {
  glue::glue(
    '<iframe ',
    'style="margin: 0px auto; min-width: 100%; overflow: hidden; height: 801px;" ',
    'id="[id]" class="interactive" src="[url]" scrolling="no" frameborder="no" ',
    'onload=\'iFrameResize({}, "#[id]")\'',
    '></iframe>',
    .open = "[", .close = "]"
  )
}

include_iframe_resizer <- function() {
  glue::glue(
    '<script src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.min.js" type="text/javascript"></script>'
  )
}
