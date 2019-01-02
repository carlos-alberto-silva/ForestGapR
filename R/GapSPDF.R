#'Forest Canopy Gaps as Spatial Polygons
#'
#'@description This function converts forest canopy gaps as RasterLayer (\code{\link[raster]{raster}}) to
#'\code{\link[sp]{SpatialPointsDataFrame-class}} objects
#'
#'@usage GapSPDF(gap_layer) 
#'
#'@param gap_layer ALS-derived gap layer (output of  \code{\link[ForestGapR:getForestGaps]{getForestGaps}} function).
#'An object of the classs RasterLayer.
#'@return A \code{\link[sp]{SpatialPointsDataFrame-class}} object of the forest canopy gaps.
#'The output file can be exported as a ESRI shapefile using
#'\code{\link[rgdal:writeOGR]{writeOGR}} function in the \emph{rgdal} package.
#'@author Carlos Alberto Silva.
#'
#'@examples
#'\dontrun{
#'#Loading raster and viridis libraries
#'library(raster)
#'library(viridis)
#'
#'# ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#'data(ALS_CHM_DUC)
#'
#'# set height thresholds (e.g. 10 meters)
#'threshold<-10
#'size<-c(1,10^4) # m2
#'
#'# Detecting forest gaps
#'gaps_duc<-getForestGaps(chm_layer=ALS_CHM_DUC, threshold=threshold, size=size)
#'
#'# Converting raster layer to SpatialPolygonsDataFrame
#'gaps_spdf<-GapSPDF(gap_layer=gaps_duc)
#'
#'# Plotting ALS-derived CHM and forest gaps
#'plot(ALS_CHM_DUC, col=viridis(10), xlim=c(173025,173125), ylim=c(9673100,96731200))
#'plot(gaps_spdf, add=TRUE, border="red", lwd=2)
#'
#'# Populating the attribute table of Gaps_spdf with gaps statistics
#'gaps_stats<-GapStats(gap_layer=gaps_duc, chm_layer=ALS_CHM_DUC)
#'gaps_spdf<-merge(gaps_spdf,gaps_stats, by="gap_id")
#'head(gaps_spdf@data)
#'}
#'@export
GapSPDF<-function(gap_layer){
  names(gap_layer)<-"gap_id"
  gaps_spdf <- raster::rasterToPolygons(x=gap_layer, fun=NULL, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)
  gaps_spdf@data<-cbind(sp::coordinates(gaps_spdf),gaps_spdf@data)
  colnames(gaps_spdf@data)<-c("x","y","gap_id")
  return(gaps_spdf)
}

