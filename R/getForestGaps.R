#' Forest Canopy Gap Detection
#'
#' @description This function detects forest canopy gaps on Airborne Laser Scanning(ALS)-derived Canopy Height Model (CHM).
#'
#' @usage getForestGaps(chm_layer, threshold=10, size=c(1,10^4))
#'
#' @param chm_layer ALS-derived Canopy Height Model (CHM) ([`terra::SpatRaster-class`]) object. An object of the class [`terra::SpatRaster-class`].
#' @param threshold Height threshold for gap detection. Default is 10 m.
#' @param size A vector containing the minimum and maximum gap size - area (m2).
#' Gaps with area < size\[1\] or area > size\[2\] are not considered. Default is 1 m2 and 1ha.
#' @return Forest Gaps. An object of the class SpatRaster.
#' @author Carlos Alberto Silva and Lucy Beese.
#' @examples
#'
#' # =======================================================================#
#' # Importing ALS-derived Canopy Height Model (CHM)
#' # =======================================================================#
#' # Loading terra and viridis libraries
#' library(terra)
#' library(viridis)
#' 
#' # ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#' data(ALS_CHM_DUC)
#'
#' # Plotting chm
#' plot(ALS_CHM_DUC, col = viridis(10), main = "ALS CHM")
#' grid()
#' # =======================================================================#
#' # Example 1: Forest Gap detection using a fixed canopy height thresholds
#' # =======================================================================#
#'
#' # set height thresholds (e.g. 10 meters)
#' threshold <- 10
#' size <- c(1, 10^4) # m2
#'
#' # Detecting forest gaps
#' gaps_duc <- getForestGaps(chm_layer = ALS_CHM_DUC, threshold = threshold, size = size)
#'
#' # Ploting gaps
#' plot(gaps_duc, col = "red", add = TRUE, main = "Forest Canopy Gap", legend = FALSE)
#'
#' # =======================================================================#
#' # Example 2: Gap detection using multiple canopy height thresholds
#' # =======================================================================#
#'
#' # set the height thresholds
#' nthresholds <- c(10, 15, 20, 25)
#' size <- c(1, 10^4) # m2
#'
#' # creating an empty vector to store multiple gaps as RasterLayers
#' gaps_stack <- c()
#'
#' # Gap detection
#' for (i in nthresholds) {
#'   gaps_i <- getForestGaps(chm_layer = ALS_CHM_DUC, threshold = i, size = size)
#'   names(gaps_i) <- paste0("gaps_", i, "m")
#'   gaps_stack[[length(gaps_stack) + 1]] <- gaps_i
#' }
#'
#' # plot gaps
#' oldpar <- par(no.readonly = TRUE)
#' par(mfrow = c(2, 2))
#' plot(ALS_CHM_DUC, col = viridis(10), main = "Height threshold 10m")
#' plot(gaps_stack[[1]], col = "red", add = TRUE, legend = FALSE)
#'
#' plot(ALS_CHM_DUC, col = viridis(10), main = "Height threshold 15m")
#' plot(gaps_stack[[2]], col = "red", add = TRUE, legend = FALSE)
#'
#' plot(ALS_CHM_DUC, col = viridis(10), main = "Height threshold 20m")
#' plot(gaps_stack[[3]], col = "red", add = TRUE, legend = FALSE)
#'
#' plot(ALS_CHM_DUC, col = viridis(10), main = "Height threshold 25m")
#' plot(gaps_stack[[4]], col = "red", add = TRUE, legend = FALSE)
#' par(oldpar)
#' @export
#' @importFrom viridis viridis
getForestGaps <- function(chm_layer, threshold = 10, size = c(1, 10^4)) {
  chm_layer[chm_layer > threshold] <- NA
  chm_layer[chm_layer <= threshold] <- 1
  gaps <- terra::patches(chm_layer, directions = 8, allowGaps = FALSE)
  rcl <- terra::freq(gaps)
  rcl[, 2] <- rcl[, 2] * terra::res(chm_layer)[1]^2
  z <- terra::classify(gaps, rcl = rcl, right = FALSE)
  z[is.na(gaps)] <- NA
  gaps[z > size[2]] <- NA
  gaps[z < size[1]] <- NA
  gaps <- terra::patches(gaps, directions = 8, allowGaps = FALSE)
  names(gaps) <- "gaps"
  return(gaps)
}
