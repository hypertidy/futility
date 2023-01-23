
.handle_args_gdalwarp <- function(
                                  ...) {
  # args <- list(...)
  # if (!is.null(args$te) && !is.null(extent)) {
  #   warning('both -te and 'extent' provided, using -te')
  # }
  # if (!is.null(args$td) && !is.null(dimension)) {
  #   warning('both -td and 'dimension' provided, using -td')
  # }
  # if (!is.null(args$t_srs) && !is.null(projection)) {
  #   warning('both -te and 'extent' provided, using -t_srs')
  # }


  ## check names %in% ? (also version checks)

}
gdalwarp <- function(srcfile, dstfile,
                     ...  ) {

      args <- list(...)
      argnames <- names(args)
      arglist <- list()
      for (i in seq_along(args)) {
        if (isTRUE(args[[i]])) {
          arglist[[i]] <- sprintf("-%s", argnames[i])
        } else {
        arglist[[i]] <- c(sprintf("-%s", argnames[i]),
          unlist(strsplit(as.character(args[[i]]), "\\s+")))
        }
      }
      opts <- as.character(unlist(arglist))
#      print(opts)
#      return()
    # [-b|-srcband n]* [-dstband n]*
    # [-s_srs srs_def] [-t_srs srs_def] [-ct string] [-to "NAME=VALUE"]* [-vshift | -novshift]
    # [[-s_coord_epoch epoch] | [-t_coord_epoch epoch]]
    # [-order n | -tps | -rpc | -geoloc] [-et err_threshold]
    # [-refine_gcps tolerance [minimum_gcps]]
    # [-te xmin ymin xmax ymax] [-te_srs srs_def]
    # [-tr xres yres] [-tap] [-ts width height]
    # [-ovr level|AUTO|AUTO-n|NONE] [-wo "NAME=VALUE"] [-ot Byte/Int16/...] [-wt Byte/Int16]
    # [-srcnodata "value [value...]"] [-dstnodata "value [value...]"]
    # [-srcalpha|-nosrcalpha] [-dstalpha]
    # [-r resampling_method] [-wm memory_in_mb] [-multi] [-q]
    # [-cutline datasource] [-cl layer] [-cwhere expression]
    # [-csql statement] [-cblend dist_in_pixels] [-crop_to_cutline]
    # [-if format]* [-of format] [-co "NAME=VALUE"]* [-overwrite]
    # [-nomd] [-cvmd meta_conflict_value] [-setci] [-oo NAME=VALUE]*
    # [-doo NAME=VALUE]*
    # srcfile* dstfile
    #
print(opts)
res <- sf::gdal_utils("warp", source = srcfile, destination = dstfile,  options = opts)
  if (!res) stop("gdalwarp app lib call failed")
   dstfile
}
