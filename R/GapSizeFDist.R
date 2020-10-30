#'Forest Canopy Gap-size Frequency Distributions
#'
#'@description This function quantifies forest canopy gap size-frequency distributions and estimates power-law exponent (\ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}}) from the Zeta distribution.
#'
#'@usage GapSizeFDist(gaps_stats,method,...)
#'
#'@param gaps_stats A data.frame containing basic statistics of forest gaps. Output of (\code{\link[ForestGapR:GapStats]{GapStats}}) function.
#'@param method If method='Asner_2013' the \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} is computed following the method described Asner et al. (2013) 
#'and if methods='Hanel_2017' the \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} is computed following the method described in Hanel et al. (2017)
#'@param ... Supplementary parameters for (\code{\link[graphics:plot]{plot}}).
#'@return A log-log plot of gap-size Frequency Distributions and a list containing: i) \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}}, ii) the gap-size Frequency Distributions and ii) method used. 
#'The \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} parameter is derived for the Zeta distribution using a maximum likelihood estimator. See details section.
#'
#'@references
#'
#'Hanel,R., Corominas-Murtra, B., Liu, B., Thurner, S. (2013). Fitting power-laws in empirical data with estimators that work for all exponents,
#'PloS one, vol. 12, no. 2, p. e0170920.https://doi.org/10.1371/journal.pone.0170920
#'
#'Asner, G.P., Kellner, J.R., Kennedy-Bowdoin, T., Knapp, D.E., Anderson, C. & Martin, R.E. (2013). 
#'Forest canopy gap distributions in the Southern Peruvian Amazon. PLoS One, 8, e60875.https://doi.org/10.1371/journal.pone.0060875
#'
#'White, E.P, Enquist, B.J, Green, J.L. (2008) On estimating the exponent of powerlaw frequency distributions. Ecology 89,905-912.
#'https://doi.org/10.1890/07-1288.1
#'
#'@examples
#'#Loading raster library
#'library(raster)
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
#'# Computing basic statistis of forest gap
#'gaps_stats<-GapStats(gap_layer=gaps_duc, chm_layer=ALS_CHM_DUC)
#'
#'# Gap-size Frequency Distributions
#'GapSizeFDist(gaps_stats=gaps_stats, method="Hanel_2017", col="forestgreen", pch=16, cex=1,
#'axes=FALSE,ylab="Gap Frequency",xlab=as.expression(bquote("Gap Size" ~ (m^2) )))
#'axis(1);axis(2)
#'grid(4,4)
#'
#'@export
GapSizeFDist<-function(gaps_stats,method="Hanel_2017",...){
  
  
  if (method=="Asner_2013") {
    
    fit <- stats::optimize(function(data, lambda){
      2*sum(-log(data^-lambda/VGAM::zeta(x=lambda)))
    }, data=gaps_stats$gap_area, lower = 1.0001, upper = 20, maximum = F)
    
    # zeta function from VGAM package
    gap.size=seq(0,max(gaps_stats$gap_area),1)
    gap.freq<-as.numeric(table(base::cut(gaps_stats$gap_area,breaks=gap.size)))
    
    graphics::plot(y=gap.freq, x =gap.size[-1], log = "xy",...)
    eqn <- bquote(lambda == .(round(fit$minimum,3)) * "," ~~ n == .(nrow(gaps_stats)))
    graphics::legend("topright",legend=eqn, bty="n")
    return(list(lambda=fit$minimum,gap.freq=cbind(gap.size=gap.size[-1],gap.freq=gap.freq), method=method))
    
  }
  
  if (method=="Hanel_2017") {
    
    a <- poweRlaw::conpl$new(gaps_stats$gap_area)
    lambda_poweRlaw <- as.numeric(poweRlaw::estimate_pars(a)[1]) #saving as a separate object
    
    gap.size=seq(0,max(gaps_stats$gap_area),1)
    gap.freq<-as.numeric(table(base::cut(gaps_stats$gap_area,breaks=gap.size)))
    
    graphics::plot(y=gap.freq, x =gap.size[-1], log = "xy",...)
    eqn <- bquote(lambda == .(round(lambda_poweRlaw,3)) * "," ~~ n == .(nrow(gaps_stats)))
    graphics::legend("topright",legend=eqn, bty="n")
    return(list(lambda=as.numeric(lambda_poweRlaw),gap.freq=cbind(gap.size=gap.size[-1],gap.freq=gap.freq), method=method))
    
  }
  
}
