#'Forest Canopy Gaps Stats
#'
#'@description This function computes a series of forest canopy gap statistics
#'
#'
#'@usage GapStats(gap_layer, chm_layer)
#'
#'@param gap_layer ALS-derived gap as RasterLayer (\code{\link[raster:raster]{raster}}) object (output of  \code{\link[ForestGapR:getForestGaps]{getForestGaps}} function). An object of the classs RasterLayer.
#'@param chm_layer ALS-derived Canopy Height Model (CHM) RasterLayer (\code{\link[raster:raster]{raster}}) used in \code{\link[ForestGapR:getForestGaps]{getForestGaps}} function. An object of the classs RasterLayer.
#'@return A data.frame containing forest canopy gap statistics
#'@author Carlos Alberto Silva.
#'@details
#'# List of forest gaps statistics:
#'\itemize{
#'\item gap_id: gap id
#'\item gap_area - area of gap (m2)
#'\item chm_max - Maximum canopy height (m) within gap boundary
#'\item chm_min - Minimum canopy height (m) within gap boundary
#'\item chm_mean - Mean canopy height (m) within gap boundary
#'\item chm_sd - Standard Deviation of canopy heights (m) within gap boundary
#'\item chm_gini - Gini Coefficient of canopy heights (m) within gap boundary
#'\item chm_range - Range of canopy heights (m) within gap boundary
#'}
#'
#'@examples
#'#Loading raster library
#'library(raster)
#'
#'# ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#'data(ALS_CHM_CAU_2012)
#'
#'# set height thresholds (e.g. 10 meters)
#'threshold<-10
#'size<-c(5,10^4) # m2
#'
#'# Detecting forest gaps
#'gaps_duc<-getForestGaps(chm_layer=ALS_CHM_DUC, threshold=threshold, size=size)
#'
#'# Computing basic statistis of forest gap
#'gaps_stats<-GapStats(gap_layer=gaps_duc, chm_layer=ALS_CHM_DUC)
#'
#'@export
GapStats <- function(gap_layer, chm_layer){
  GiniCoeff <- function (x, finite.sample = TRUE, na.rm = TRUE){
    if (!na.rm && any(is.na(x))) 
      return(NA_real_)
    x <- as.numeric(stats::na.omit(x))
    n <- length(x)
    x <- sort(x)
    G <- 2 * sum(x * 1L:n)/sum(x) - (n + 1L)
    if (finite.sample) 
      GC <- G/(n - 1L)
    else GC <- G/n
    return(GC)
  }
  gap_list <- data.frame(raster::freq(gap_layer))
  gap_list$count <- gap_list$count*raster::res(chm_layer)[1]^2
  gap_list <- gap_list[!is.na(gap_list[,1]),]
  gap_list$chm_max <- tapply(chm_layer[], gap_layer[], max)
  gap_list$chm_min <- tapply(chm_layer[], gap_layer[], min)
  gap_list$chm_mean <- round(tapply(chm_layer[], gap_layer[], mean), 2)
  gap_list$chm_sd <- round(tapply(chm_layer[], gap_layer[], stats::sd), 2)
  gap_list$chm_gini <- round(tapply(chm_layer[], gap_layer[], GiniCoeff), 2)
  gap_list$chm_range <- round(gap_list$chm_max - gap_list$chm_min, 2)
  colnames(gap_list) <- c("gap_id", "gap_area", "chm_max", "chm_min", "chm_mean", "chm_sd", "chm_gini", "chm_range")
  return(gap_list)
}