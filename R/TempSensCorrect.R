#' Function to correct air-temperature data from self-built sensors

#' @param v Vector with temperature data from self-built sensor that needs correction.
#' @param glob.rad Vector that contains values of global radiation (W/m2) for each value of v. i.e. must be same length as v.
#' @param inter intercept of relationship between slef-built sensor and calibrated sensor. Default determined from a calibration experiment.
#' @param slope slope of relationship between slef-built sensor and calibrated sensor. Default set from calibration experiment.
#' @return Vector with the calibrated values.
#' @ examples
#' \dontrun{
#' Temp.func <- TempSensCorrect(co.temp$Temp_Avg, glob.rad = co.temp$Ave.GSR..W.m.2.)
#' }
#' @export

TempSensCorrect <- function(v, glob.rad, inter = -2.899, slope = 1.181) {

    # based on comparison of the self-built sensors with a commercial sensor (MEA)
    # analysis of relatioship from script
    # "Sensor_comparison_rH_temp_self-built_vs_Agface.R"

    # correction based on linear regression alone
    # correction only applies when global radiation values are above 100 W/m2
    
    # inter = 2.563, slope = 1.0396
    # full light-range correlation coefficients: inter = 1.558, slope = 1.057
    # weigted by 1/ glob.rad: 1.5996 slope 1.0540
    # but using the correlation for glob.rad > 100 W/m2 only

      stopifnot(length(glob.rad) == length(v))
                   
      v <- ifelse(glob.rad > 100,
                  v + inter * slope, 
                  v)
      return(v)
}

# test case
#co.temp$Temp.func <- TempSensCorrect(co.temp$Temp_Avg, glob.rad = co.temp$Ave.GSR..W.m.2.)

#p <- ggplot(co.temp, aes(x = Temp.cor, y = Temp.func))
#  p <- p + geom_point()
#p

#p <- ggplot(co.temp, aes(x = TIMESTAMP))
#  p <- p + geom_point(aes(y = Temp.cor))
#  p <- p + geom_line(aes(y = Temp.func, colour = SensorID))
#  #p <- p + geom_line(aes(y = Temp.cor, colour = SensorID), alpha = 0.3, size = rel(0.2), 
#  #                   linetype = "dashed")
#  p <- p + facet_grid(SYSTEM ~ .)
#p
