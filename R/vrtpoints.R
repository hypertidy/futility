#' Title
#'
#' @param pts
#' @param name
#'
#' @return
#' @export
#'
#' @examples
#' n <- 500
#' rc <- cbind(sample(nrow(volcano), n, replace = TRUE), sample(ncol(volcano), n, replace = TRUE))
#' xyz <- cbind(rc, volcano[rc])
#' plot(xyz[,2:1], col = palr::d_pal(xyz[,3]), pch = 19, cex = .3)
#' file <- vrtpoints(xyz)
#' sf::gdal_utils("grid", file, tf <- tempfile(fileext = ".tif"))
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
