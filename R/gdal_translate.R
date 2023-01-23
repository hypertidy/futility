#' Title
#'
#' @param x
#' @param extent
#' @param resample
#' @param limit
#'
#' @return
#' @export
#'
#' @examples
#' src <- "/vsicurl/https://github.com/hypertidy/whatarelief/raw/main/inst/extdata/world_cog_test.tif"
#' ## the src is aligned to 0,0.5
#' projwin(src)
#' projwin(src)
projwin <- function(x, extent = NULL, resample = "near", limit = TRUE) {

  info <- vapour::vapour_raster_info(x)
  if (limit && prod(info$dimension) > 1e7 ) stop(sprintf("this raster is big: %s %s", info$dimension[1L], info$dimension[2L]))
  if (is.null(extent)) {
    extent <- info$extent
  }
  ## build this into vapour/inst/include/gdalapplib/gdalapplib.h
  sf::gdal_utils("translate", x, tf <- tempfile(fileext = ".tif"),
                 options = c("-r", resample,
                            "-outsize", info$dimension[1], info$dimension[2],
                            "-projwin", extent[1], extent[4], extent[2L], extent[3L]))

   out <- vapour::vapour_raster_info(tf)$extent
  unlink(tf)
  out
}


tapwin <- function(x, extent = NULL, dimension = NULL, resample = "near", limit = TRUE, tr = NULL, tap = NULL) {

  info <- vapour::vapour_raster_info(x)
  #if (is.null(dimension)) dimension <- info$dimension
  if (limit && prod(info$dimension) > 1e7 ) stop(sprintf("this raster is big: %s %s", info$dimension[1L], info$dimension[2L]))
  if (is.null(extent)) {
    extent <- info$extent
  }
  if (!is.null(tr)) {
    tr <- c("-tr", tr)
  }
  ts <- NULL
  if (!is.null(dimension)) {
    ts <- c("-ts", dimension)
  }
  te <- NULL
  if (!is.null((extent))) {
    te <- c("-te", extent[1], extent[3], extent[2L], extent[4L])
  }
  opts <- c("-r", resample,
                            tr, ts, te,
                            tap)

  ## build this into vapour/inst/include/gdalapplib/gdalapplib.h
  sf::gdal_utils("warp", x, tf <- tempfile(fileext = ".tif"),
                 options = opts)
   out <- vapour::vapour_raster_info(tf)$extent
  unlink(tf)
  out

}
