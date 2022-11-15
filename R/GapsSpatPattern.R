#' Spatial Pattern Analysis of Forest Canopy Gaps
#'
#'
#' @description This function computes second order statistics of forest canopy gaps ([`raster::RasterLayer-class`]) to
#' [`sp::SpatialPointsDataFrame-class`] objects
#'
#'
#' @param gap_SPDF_layer A [`sp::SpatialPointsDataFrame-class`] object of the forest canopy gaps.
#' Output of [GapSPDF()] function.
#' An object of the class [`sp::SpatialPointsDataFrame-class`]
#' @param chm_layer ALS-derived Canopy Height Model (CHM) ([`raster::RasterLayer-class`]) object. An object of the class [`raster::RasterLayer-class`].
#' @return A plot with Ripley's K- and L-functions. Value of Clark-Evans index (R) and test for randomness (R=1), aggregation (R<1) or uniform distribution (R>1).
#' @author Ruben Valbuena and Carlos Alberto Silva.
#' @references
#' [`spatstat`][spatstat.explore::spatstat.explore-package] package, see [`Lest()`][spatstat.explore::Lest()], [`Kest()`][spatstat.explore::Kest()],
#' and [`clarkevans.test()`][spatstat.explore::clarkevans.test()].
#'
#' @examples
#' # This takes > 5 seconds!
#' \donttest{
#' # Loading raster and viridis libraries
#' library(raster)
#' library(viridis)
#'
#' # ALS-derived CHM from Fazenda Cauxi - Brazilian tropical forest
#' data(ALS_CHM_CAU_2012)
#' data(ALS_CHM_CAU_2014)
#'
#' # set height thresholds (e.g. 10 meters)
#' threshold <- 10
#' size <- c(1, 1000) # m2
#'
#' # Detecting forest gaps
#' gaps_cau2012 <- getForestGaps(chm_layer = ALS_CHM_CAU_2012, threshold = threshold, size = size)
#' gaps_cau2014 <- getForestGaps(chm_layer = ALS_CHM_CAU_2014, threshold = threshold, size = size)
#'
#' # Converting raster layers to SpatialPolygonsDataFrame
#' gaps_cau2012_spdf <- GapSPDF(gap_layer = gaps_cau2012)
#' gaps_cau2014_spdf <- GapSPDF(gap_layer = gaps_cau2014)
#'
#' # Spatial pattern analysis of each year
#' gaps_cau2012_SpatPattern <- GapsSpatPattern(gaps_cau2012_spdf, ALS_CHM_CAU_2012)
#' gaps_cau2014_SpatPattern <- GapsSpatPattern(gaps_cau2014_spdf, ALS_CHM_CAU_2014)
#' }
#' @export
GapsSpatPattern <- function(gap_SPDF_layer, chm_layer) {
  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(oldpar)) 
  P <- spatstat.geom::as.ppp(sp::coordinates(gap_SPDF_layer), raster::extent(chm_layer)[])
  K <- spatstat.explore::envelope(P, spatstat.explore::Kest, nsim = 99, verbose = F)
  L <- spatstat.explore::envelope(P, spatstat.explore::Lest, nsim = 99, verbose = F)
  graphics::par(mfrow = c(1, 2), mar = c(6, 5, 4, 2))
  graphics::plot(K)
  graphics::plot(L)
  CE <- spatstat.explore::clarkevans.test(P)
  return(CE)
}
