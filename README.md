[![Build Status](https://travis-ci.org/MarkusLoew/MySensorCorrect.svg?branch=master)](https://travis-ci.org/MarkusLoew/MySensorCorrect)

# MySensorCorrect
Correction functions for my self-built temperature and relative humidity sensors.

Corrections as recommended by the manufacturers:
Relative humidity sensor
added temperature correction for _Honeywell HIH-4000 relative humidity sensor_
Honeywell, Golden Valley, MN, USA
True RH = (Sensor RH)/(1.0546 – 0.00216T), T in ºC
For temperature correction of relative humidity
Const Humcor_a = 1.0546
Const Humcor_b = 0.00216

_Temperature sensor IST TSic 301 (IST AG, Wattwil, Switzerland)_
implementing equation from manual
'T = Sig[V] * (HT - LT)+ LT [°C]
'LT = -50, 2 HT = 150 as standard value for the temperature calculation

After that, a cross-comparison between high-quality sensors and these se;f-built ones were performed. The resulting corrections are provided in the R-package.
