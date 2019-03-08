#' Get rainfall from CML total losses
#'
#' This function converts CML total lossese to rainfall intensities.

#' @param tl Vector with total measured loss in dB, i.e. difference between transmit (tx) and recive signal levels (rx)
#' @param fr CML frequency
#' @param pol CML polarization, 'V' as vertical or 'H' as horizontal. Default is 'V'.
#' @param LonA,LatA,LonB,LatB Longitudes and Latitudes of CML end nodes A and B. In the form of Decimal number.
#' @param m Low-pass filter in baseline identification (Fenicia, et al. 2012). Default is 0.0568.
#' @param tsh threshold parametr for classification of sudden peaks which are assumed to hardware errors (dB).
#' @references  Fenicia, Fabrizio, Laurent Pfister, Dmitri Kavetski, Patrick Matgen, Jean-Francois Iffly, Lucien Hoffmann, and Remko Uijlenhoet. "Microwave Links for Rainfall Estimation in an Urban Environment: Insights from an Experimental Setup in Luxembourg-City." Journal of Hydrology 464-465 (September 25, 2012): 69-78. https://doi.org/10.1016/j.jhydrol.2012.06.047.
#' @keywords CML rainfall
#' @export
#' @examples
#' tl <- c(rep(45, 500), 45 - c(1,3,2,5,10,6,2,8,2,1,3,1,1,0.5), rep(45, 500))
#' tl <- round(tl + rnorm(tl, 0, .3), 1)
#' R <- get_CMLrainfall (tl, 38, 'V', 15.11, 50.11, 15.13, 50.12, 0.00568, tsh = 5)
#' layout(matrix(1 : 2))
#' plot (tl, type = 'l', ylab = 'TL (dB)', xlim =c(400,600), main = 'Total Loss')
#' plot(R, type = 'l', main = 'Rainfall', ylab = 'R (mm/h)', xlim =c(400,600))


get_CMLrainfall4 <- function (tl, fr, pol = 'V', LonA, LatA, LonB, LatB,
                             m = .00568, tsh = 5) {
  require(geosphere)
  
  # Filter sudden peaks in tl data and separate baseline and WAA (1.5 dB)
  tl <- filter_peaks (tl, tsh, report = F, peaksAsNAs = T) 
  B <- basel_fenicia (tl, m)
  A <- tl - B
  A[A < 0] <- 0
  A <- A - 1.5
  A[A < 0] <- 0
  
  # get metadata and attneuation-rainfall parameters
  L <- distGeo(c(LonA, LatA), c(LonB, LatB)) / 1000
  p <- as.numeric(get_ITU_pars(fr, pol))
  
  k <- A/L  # specific rain-induceed attenuation (dB/km)
  R <- p[1] * k ^ p[2]
  
  return (R)
  
}




