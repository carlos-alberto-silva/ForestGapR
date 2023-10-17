#' Forest Canopy Gaps Stats
#'
#' @description This function computes a series of forest canopy gap statistics
#'
#'
#' @usage GapStats(gap_layer, chm_layer)
#'
#' @param gap_layer ALS-derived gap as [`terra::SpatRaster-class`] object (output of  [getForestGaps()] function). An object of the class SpatRaster.
#' @param chm_layer ALS-derived Canopy Height Model (CHM) [`terra::SpatRaster-class`] used in [getForestGaps()] function. An object of the class [`terra::SpatRaster-class`].
#' @return A data.frame containing forest canopy gap statistics
#' @author Carlos Alberto Silva and Lucy Beese.
#' @details
#' # List of forest gaps statistics:
#' \itemize{
#' \item gap_id: gap id
#' \item gap_area - area of gap (m2)
#' \item chm_max - Maximum canopy height (m) within gap boundary
#' \item chm_min - Minimum canopy height (m) within gap boundary
#' \item chm_mean - Mean canopy height (m) within gap boundary
#' \item chm_sd - Standard Deviation of canopy heights (m) within gap boundary
#' \item chm_gini - Gini Coefficient of canopy heights (m) within gap boundary
#' \item chm_range - Range of canopy heights (m) within gap boundary
#' }
#'
#' @examples
#' # Loading terra library
#' library(terra)
#'
#' # ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#' data(ALS_CHM_CAU_2012)
#'
#' # set height thresholds (e.g. 10 meters)
#' threshold <- 10
#' size <- c(5, 10^4) # m2
#'
#' # Detecting forest gaps
#' gaps_duc <- getForestGaps(chm_layer = ALS_CHM_DUC, threshold = threshold, size = size)
#'
#' # Computing basic statistics of forest gap
#' gaps_stats <- GapStats(gap_layer = gaps_duc, chm_layer = ALS_CHM_DUC)
#' @export
GapStats <- function(gap_layer, chm_layer) {
  GiniCoeff <- function(x, finite.sample = TRUE, na.rm = TRUE) {
    if (!na.rm && any(is.na(x))) {
      return(NA_real_)
    }
    x <- as.numeric(stats::na.omit(x))
    n <- length(x)
    x <- sort(x)
    G <- 2 * sum(x * 1L:n) / sum(x) - (n + 1L)
    if (finite.sample) {
      GC <- G / (n - 1L)
    } else {
      GC <- G / n
    }
    return(GC)
  }
  
  Range_Func <- function(x) {
    max_val <- max(x, na.rm = TRUE)
    min_val <- min(x, na.rm = TRUE)
    range_val <- max_val - min_val
    return(range_val)
  }
  
  gap_list <- data.frame(terra::freq(gap_layer))
  gap_list$layer<-NULL
  gap_list$count <-gap_list$count * terra::res(gap_layer)[1]^2
  gap_list <- gap_list[!is.na(gap_list[, 1]), ]
  
  chm_max <- stats::aggregate(chm_layer[], by = list(gap_layer[]), FUN = max)
  chm_min <- stats::aggregate(chm_layer[], by = list(gap_layer[]), FUN = min)
  chm_mean <- round(stats::aggregate(chm_layer[], by = list(gap_layer[]), FUN = mean), 2)
  chm_sd <- round(stats::aggregate(chm_layer[], by = list(gap_layer[]), FUN = sd), 2)
  chm_gini <- round(stats::aggregate(chm_layer[], by = list(gap_layer[]), GiniCoeff), 2)
  chm_range <- round(stats::aggregate(chm_layer[], by = list(gap_layer[]), Range_Func), 2)
  
  # Rename columns
  colnames(gap_list) <- c("gap_id", "gap_area")
  colnames(chm_max) <- c("gap_id", "chm_max")
  colnames(chm_min) <- c("gap_id", "chm_min")
  colnames(chm_mean) <- c("gap_id", "chm_mean")
  colnames(chm_sd) <- c("gap_id", "chm_sd")
  colnames(chm_gini) <- c("gap_id", "chm_gini")
  colnames(chm_range)<- c("gap_id", "chm_range")
  
  # Merge all results into one data frame
  gap_list <- merge(gap_list, chm_max, by = "gap_id")
  gap_list <- merge(gap_list, chm_min, by = "gap_id")
  gap_list <- merge(gap_list, chm_mean, by = "gap_id")
  gap_list <- merge(gap_list, chm_sd, by = "gap_id")
  gap_list <- merge(gap_list, chm_gini, by = "gap_id")
  gap_list <- merge(gap_list, chm_range, by = "gap_id")
  
  return(gap_list)
}
