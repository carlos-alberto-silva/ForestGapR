#'Forest Canopy Gap-size Frequency Distributions
#'
#'@description This function quantify the size frequency distribution of forest canopy gaps using  Zeta distribution,
#'which is a discrete power-law probability density.
#'
#'@usage GapSizeFDist(gaps_stats,...)
#'
#'@param gaps_stats A data.frame containing basic statistics of forest gaps. Output of (\code{\link[ForestGapR:GapStats]{GapStats}}) function.
#'@param ... Supplementary parameters for (\code{\link[graphics:plot]{plot}}).
#'@return A log-log plot of gap-size Frequency Distributions and a vector containing the \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} and
#'minimum value of the likelihood. The parameter \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} is the scaling exponent for the
#'power-law Zeta distribution fitted to the data using maximum likelihood. See details section.
#'
#'@author Carlos Alberto Silva.
#'
#'@section Details: For the Zeta distribution with parameter \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}}, the probability that gap size takes
#'the integer value k is:
#'\deqn{f(k) =\frac{k^{-\lambda}}{]\\zeta(\lambda)}}{f(k) = k^-\lambda/\zeta(\lambda)}
#'where the denominator is the Riemann zeta function, and is undefined for \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} = 1.
#'The function calculates maximum likelihood estimates (MLE) of \ifelse{latex}{\out{$\lambda$}}{\ifelse{html}{\out{&lambda;}}{lambda}} by minimizing a negative
#'log-likelihood function (Asner et 2013).
#'
#'@references
#'Asner, G.P., Kellner, J.R., Kennedy-Bowdoin, T., Knapp, D.E., Anderson, C. & Martin, R.E. (2013). Forest canopy gap distributions in the Southern Peruvian Amazon. PLoS One, 8, e60875.
#'
#'White EP, Enquist BJ, Green JL (2008) On estimating the exponent of powerlaw frequency distributions. Ecology 89: 905–912.
#'
#'@examples
#'#Loading raster library
#'library(raster)
#'
#'# ALS-derived CHM over Adolpho Ducke Forest Reserve - Brazilian tropical forest
#'data(ALS_CHM_DUC)
#'
#'# set height tresholds (e.g. 10 meters)
#'threshold<-10
#'size<-c(1,1000) # m2
#'
#'# Detecting forest gaps
#'gaps_duc<-getForestGaps(chm_layer=ALS_CHM_DUC, threshold=threshold, size=size)
#'
#'# Computing basic statistis of forest gap
#'gaps_stats<-GapStats(gap_layer=gaps_duc, chm_layer=ALS_CHM_DUC)
#'
#'# Gap-size Frequency Distributions
#'GapSizeFDist(gaps_stats=gaps_stats, col="forestgreen", pch=16, cex=1,
#'axes=FALSE,ylab="Gap Frequency",xlab=as.expression(bquote("Gap Size" ~ (m^2) )))
#'axis(1);axis(2)
#'grid(4,4)
#'
#'@export
GapSizeFDist<-function(gaps_stats,...){
  # zeta function from VGAM package
  thehist <-  graphics::hist(gaps_stats$gap_area, br=seq(0,max(gaps_stats$gap_area),1), plot=F)
  fit <- stats::optimize(function(data, lambda){
     2*sum(-log(data^-lambda/VGAM::zeta(x=lambda)))
  }, data=gaps_stats$gap_area, lower = 1.0001, upper = 20, maximum = F)

  graphics::plot(y=thehist$counts, x=thehist$breaks[2:length(thehist$breaks)],log="xy",...)
  eqn <- bquote(lambda == .(round(fit$minimum,3)) * "," ~~ n == .(nrow(gaps_stats)))
  graphics::legend("topright",legend=eqn, bty="n")
  return(c(lambda=fit$minimum,likelihood=fit$objective))
}

