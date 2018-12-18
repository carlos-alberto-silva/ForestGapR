#'Spatial Polygons of Forest Canopy Gaps
#'
#'@description This function converts forest canopy gaps as RasterLayer (\code{\link[raster]{raster}}) to
#'\code{\link[sp]{SpatialPolygonsDataFrame}} objects
#'
#'@usage GapSPDF(gap_layer)
#'
#'@param gap_layer ALS-derived gap layer (output of  \code{\link[GapForestR:getForestGaps]{getForestGaps}} function).
#'An object of the classs RasterLayer.
#'@return A \code{\link[sp:SpatialPolygonsDataFrame]{SpatialPolygonsDataFrame}} object of the forest canopy gaps.
#'The output file can be exported as a ESRI shapefile using
#'\code{\link[rgdal:writeOGR]{writeOGR}} function in the \emph{rgdal} package.
#'@author Carlos Alberto Silva.
#'
#'@examples
#'\dontrun{
#'#Loading raster library
#'library(raster)
#'
#'# ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#'data(ALS_CHM_CAU_2012)
#'
#'# set height tresholds (e.g. 10 meters)
#'threshold<-10
#'size<-c(1,1000) # m2
#'
#'# Detecting forest gaps
#'gaps_duc<-getForestGaps(chm_layer=ALS_CHM_DUC, threshold=threshold, size=size)
#'
#'# Converting raster layer to SpatialPolygonsDataFrame
#'gaps_spdf<-GapSPDF(gap_layer=gaps_duc)
#'
#'# Plotting ALS-derived CHM and forest gaps
#'plot(ALS_CHM_DUC, col=gray(seq(0,1,len=20)))
#'plot(gaps_spdf, add=TRUE, col="red",alpha = 0.5)
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
  #colnames(gaps_spdf@data)<-"gap_id"
  gaps_spdf@data<-cbind(sp::coordinates(gaps_spdf),gaps_spdf@data)
  return(gaps_spdf)
}

