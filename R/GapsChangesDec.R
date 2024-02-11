#' Forest Gaps Change Detection
#'
#' @description This function detects forest canopy gap changes across two forest gap [`terra::SpatRaster-class`] objects
#'
#' @usage GapChangeDec(gap_layer1,gap_layer2)
#'
#' @param gap_layer1 ALS-derived gap as an [`terra::SpatRaster-class`] object at time 1. (output of  [getForestGaps()] function).
#' @param gap_layer2 ALS-derived gap as an [`terra::SpatRaster-class`] object at time 2. (output of  [getForestGaps()] function).
#' @return A [`terra::SpatRaster-class`] object representing forest gap change area
#' @author Carlos Alberto Silva and Lucy Beese.
#'
#' @examples
#' \dontrun{
#' # Loading terra and viridis libraries
#' library(terra)
#' library(viridis)
#' 
#'
#' # ALS-derived CHM from Fazenda Cauxi - Brazilian tropical forest
#' ALS_CHM_CAU_2012 <- rast(system.file("tif/ALS_CHM_CAU_2012.tif", package = "ForestGapR"))
#' ALS_CHM_CAU_2014 <- rast(system.file("tif/ALS_CHM_CAU_2014.tif", package = "ForestGapR"))
#'
#' # set height thresholds (e.g. 10 meters)
#' threshold <- 10
#' size <- c(1, 10^4) # m2
#'
#' # Detecting forest gaps
#' gaps_cau2012 <- getForestGaps(chm_layer = ALS_CHM_CAU_2012, threshold = threshold, size = size)
#' gaps_cau2014 <- getForestGaps(chm_layer = ALS_CHM_CAU_2014, threshold = threshold, size = size)
#'
#' # Detecting forest gaps changes
#' Gap_changes <- GapChangeDec(gap_layer1 = gaps_cau2012, gap_layer2 = gaps_cau2014)
#'
#' # Plotting ALS-derived CHM and forest gaps
#' oldpar <- par(mfrow = c(1, 3))
#' plot(ALS_CHM_CAU_2012, main = "Forest Canopy Gap - 2012", col = viridis(10))
#' plot(gaps_cau2012, add = TRUE, col = "red", legend = FALSE)
#'
#' plot(ALS_CHM_CAU_2014, main = "Forest Canopy Gap - 2014", col = viridis(10))
#' plot(gaps_cau2014, add = TRUE, col = "red", legend = FALSE)
#'
#' plot(ALS_CHM_CAU_2014, main = "Forest Gap Changes Detected", col = viridis(10))
#' plot(Gap_changes, add = TRUE, col = "orange", legend = FALSE)
#' par(oldpar)
#' }
#' @import igraph
#' @export
GapChangeDec <- function(gap_layer1, gap_layer2) {
  gap_layer1[!is.na(gap_layer1)] <- 1
  gap_layer2[!is.na(gap_layer2)] <- 2
  gap_layer1[is.na(gap_layer1)] <- 0
  gap_layer2[is.na(gap_layer2)] <- 0
  gap_diff <- gap_layer2 - gap_layer1
  gap_diff[gap_diff[] != 2] <- NA
  return(gap_diff)
}
