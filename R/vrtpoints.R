#' GDAL grid
#'
#' Runs the gdal_grid utility.
#'
#' Algorithms listed at https://gdal.org/programs/gdal_grid.html#interpolation-algorithmsuse
#'
#' Pass in paramaters the algorithm name, e. g. 'invdist:power=2.0:smoothing=1.0' - see examples.
#' @param pts points, columns of X, Y, Z
#' @param dimension ncols, nrows
#' @param extent xmin,xmax,ymin,ymax
#' @param algorithm one of invdist, invdistnn, average, linear see Details
#' @return matrix of raster values, numeric
#' @export
#'
#' @examples
#' n <- 500
#' rc <- cbind(sample(nrow(volcano), n, replace = TRUE), sample(ncol(volcano), n, replace = TRUE))
#' xyz <- cbind(rc, volcano[rc])
#' ex <- c(range(xyz[,1]), range(xyz[,2]))
#' v <- gdal_grid(xyz, extent = ex)
#'
#' ximage::ximage(v, extent = ex, asp = 1)
#'
#' v1 <- gdal_grid(xyz, extent = ex, algorithm = "invdist:power=2.0:smoothing=1.0 ")
gdal_grid <- function(pts, dimension = c(256, 256), extent = NULL, algorithm = "linear", read = TRUE, options = NULL) {
  if (is.null(extent)) {
    extent <- c(range(pts[,1]), range(pts[,2]))
  }
  file <- vrtpoints(pts)
  print(file)
  ## build this into vapour/inst/include/gdalapplib/gdalapplib.h
  sf::gdal_utils("grid", file, tf <- tempfile(fileext = ".tif"),
                 options = c("-a", algorithm,
                            "-outsize", dimension[1], dimension[2],
                            "-txe", extent[1], extent[2],
                            "-tye", extent[3], extent[4]))

  if (read) {
    out <- matrix(vapour::vapour_warp_raster_dbl(tf, dimension = dimension, extent = extent), dimension[2L], byrow = TRUE)
  } else {
    out <- tf
  }
  unlink(tf)
  out
}


#' Write points xyz to CSV for GDAL.
#'
#' Obtain a filename that wraps a CSV file with the input points in it. This is suitable
#' for use with [gdal_grid]() the command line utility, but see [gdal_grid()] the function
#' for a convenient wrapper.
#'
#' @param pts data frame or matrix of points, X, Y, Z
#' @param name optional, used as the layername in the GDAL source
#'
#' @return path to tempfile
#' @export
#'
#' @examples
#' n <- 500
#' rc <- cbind(sample(nrow(volcano), n, replace = TRUE), sample(ncol(volcano), n, replace = TRUE))
#' xyz <- cbind(rc, volcano[rc])
#' plot(xyz[,2:1], col = palr::d_pal(xyz[,3]), pch = 19, cex = .3)
#' file <- vrtpoints(xyz)
#' sf::gdal_utils("grid", file, tf <- tempfile(fileext = ".tif"))
#' sf::read_sf(file)
#' sf::gdal_utils("info", tf)
vrtpoints <- function(pts, name = NULL) {

  if (ncol(pts) !=3 ) stop("must be 3 columns")
  colnames(pts) <- c("x", "y", "z")
  if (is.null(name)) name <- paste0(sample(letters, 10), collapse = "")
  temp <- tempfile(name, fileext = ".csv")

vrttemplate <- '  <OGRVRTDataSource>
    <OGRVRTLayer name="%s">
        <SrcLayer>%s</SrcLayer>
        <SrcDataSource>%s</SrcDataSource>
        <GeometryType>wkbPoint</GeometryType>
        <LayerSRS>WGS84</LayerSRS>
        <GeometryField separator="," encoding="PointFromColumns" x="x" y="y" z="z"/>
    </OGRVRTLayer>
</OGRVRTDataSource>'

layer <- gsub("\\.csv", "", basename(temp))
vrt <- sprintf(vrttemplate,
               layer,
               layer,
               temp)

readr::write_csv(as.data.frame(pts), temp, progress = FALSE)
writeLines(vrt, tf <- tempfile(fileext = ".vrt"))
tf
}
