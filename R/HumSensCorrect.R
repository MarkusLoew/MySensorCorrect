#' Function to clean relative humidity data from self-built sensors
#'
#' @param v Vector that contains the measured relative humidity values
#' @param t.inter Intercept of the temperature correction. Default provided. Numeric.
#' @param t.slope Slope of the temperature correction. Default provided. Numeric.
#' @param min.rescale Minimal relative humidity that was found at the site. Used set the range of the rH% values. Default provided from the calibration experiment. Numeric.
#' @param max.rescale Maximum relative humidity that was found at the site. Used set the range of the rH% values. Default provided from the calibration experiment. Numeric.
#' @param poly.a First coefficient of the calibration polynom (a * v^2 + b * v + c). Default provided from calibration experiment.
#' @param poly.b First coefficient of the calibration polynom (a * v^2 + b * v + c). Default provided from calibration experiment.
#' @param poly.c First coefficient of the calibration polynom (a * v^2 + b * v + c). Default provided from calibration experiment.
#' @return Vector with the calibrated and re-scaled relative humidity values.
#' @examples
#' \dontrun{
#' co.hum$Hum.func <- HumSensCorrect(co.hum$Hum_Avg)
#' }
#' @export

HumSensCorrect <- function(v, 
                           t.inter = 5.404, t.slope = 1.0745,
                           min.rescale = 7.5, max.rescale = 98.8,
                           poly.a = 0.002462, poly.b = 0.7320, poly.c = 7.579) {
# based on comparison of the self-built sensors with a commercial sensor (MEA)
# analysis of relatioship from script
# "Sensor_comparison_rH_temp_self-built_vs_Agface.R"

# Principle:
# 1) remove values of > 100 and < 0
# 2) apply linear temperature correction from coef.hum 
#    co.hum$Hum_Avg + co.hum$inter * co.hum$slope
# 3) re-scale values to be in the range from 7.5% to 98.8%
# 4) apply polynomal correction from coef.hum.poly via 
#    a * Hum.cor.rescale^2 + b * Hum.cor.rescale + c

# default for t.inter is the mean from the above script: 5.404
# default for t.slope is the mean from the above script: 1.0745
# default for min.rescale is the minumum during the calibration: 7.5
# default for max.rescale is the minumum during the calibration: 98.8
# default for polynom coefficients a, b, c: 0.0.002462, 0.7320, 7.579

# polynom fit mean adj r2 = 0.9805

     stopifnot(class(v) %in% c("numeric", "integer"))
     stopifnot("scales" %in% rownames(installed.packages()))
     # correct values above 100 to be 100 # not NA 
     v <- ifelse(v <= 0, NA, v)
     
     # remove values below 0
     v <- ifelse(v > 100, 100, v)
     
     # apply temperature correction
     v <- v + t.inter * t.slope
     
     # rescale v to be in the range of the calibrated sensor
     v <-  scales::rescale(v, to = c(min.rescale, max.rescale))
     
     # apply polynomal correction
     v <- poly.a * v^2 + poly.b * v + poly.c
     
     # another data cleanup, in case the calibration procedure caused values above 100 or below 0
     # remove values above 100
     v <- ifelse(v <= 0, NA, v)
     
     # remove values below 0
     v <- ifelse(v > 100, NA, v)
     
     return(v)
}


# testcases
#co.hum$Hum.func <- HumSensCorrect(co.hum$Hum_Avg)

#p <- ggplot(co.hum, aes(x = Hum.poly, y = Hum.func))
#  p <- p + geom_point()
#p

#p <- ggplot(co.hum, aes(x = TIMESTAMP))
#  p <- p + geom_line(aes(y = Hum.func, colour = SensorID))
# # p <- p + geom_line(aes(y = Hum.poly, linetype = SensorID))
# # p <- p + geom_line(aes(y = Ave.Humidity....), colour= "blue")
#  p <- p + facet_grid(SYSTEM ~ .)
#  p <- p + geom_hline(yintercept = c(0, 100))
#p

