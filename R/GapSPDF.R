#' Forest Canopy Gaps as Spatial Polygons
#'
#' @description This function converts forest canopy gaps as [`terra::SpatRaster-class`] to
#' [`sp::SpatialPointsDataFrame-class`] objects
#'
#' @usage GapSPDF(gap_layer)
#'
#' @param gap_layer ALS-derived gap layer (output of [getForestGaps()] function).
#' An object of the class SpatRaster.
#' @return A [`sp::SpatialPointsDataFrame-class`] object of the forest canopy gaps.
#' The result can be converted to a SpatVector and exported as a ESRI shapefile using
#' [terra::writeVector()] function in the \emph{terra} package.
#' @author Carlos Alberto Silva.
#'
#' @examples
#' # Loading terra and viridis libraries
#' library(terra)
#' library(viridis)
#' library(sf)
#' library(sp)
#'
#' # ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#' data(ALS_CHM_DUC)
#'
#' # set height thresholds (e.g. 10 meters)
#' threshold <- 10
#' size <- c(1, 10^4) # m2
#'
#' # Detecting forest gaps
#' gaps_duc <- getForestGaps(chm_layer = ALS_CHM_DUC, threshold = threshold, size = size)
#'
#' # Converting raster layer to SpatialPolygonsDataFrame
#' gaps_spdf <- GapSPDF(gap_layer = gaps_duc)
#'
#' # Plotting ALS-derived CHM and forest gaps
#' plot(ALS_CHM_DUC, col = viridis(10), xlim = c(173025, 173125), ylim = c(9673100, 96731200))
#' plot(gaps_spdf, add = TRUE, border = "red", lwd = 2)
#'
#' # Populating the attribute table of Gaps_spdf with gaps statistics
#' gaps_stats <- GapStats(gap_layer = gaps_duc, chm_layer = ALS_CHM_DUC)
#' gaps_spdf <- merge(gaps_spdf, gaps_stats, by = "gap_id")
#' head(gaps_spdf@data)
#' # Convert to SpatVector for export 
#' terra::vect(gaps_spdf)
#' # Save the SpatVector object to the Shapefile
  terra::writeVector(gaps_spdf, 'output_shapefile.shp', overwrite = TRUE)

GapSPDF <- function(gap_layer){
  gaps_poly <- terra::as.polygons(gap_layer, dissolve=TRUE, na.rm=TRUE, values=TRUE)
  names(gaps_poly) <- "gap_id"
  gaps_sf <- sf::st_as_sf(gaps_poly)
  gaps_df <- terra::as.data.frame(terra::centroids(gaps_poly), geom="XY")
  sf_polys<- sf::as_Spatial(gaps_sf)
  gaps_spdf<- sp::SpatialPolygonsDataFrame(sf_polys, gaps_df)
  return(gaps_spdf)
}
