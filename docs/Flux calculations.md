# Level 0: Preliminary flux calculations

- More details can be found in the documentation of the [Flux Processing Chain](https://www.swissfluxnet.ethz.ch/index.php/data/ecosystem-fluxes/flux-processing-chain/#Step_2_Level-0_Preliminary_Flux_Calculations_With_OPENLAG_and_Other_Tests)
- Generally, preliminary flux calculations were used to check whether the flux processing works, to check the wind direction across years and to determine appropriate time windows for lag search for final flux calculations (Level-1)

## OPENLAG runs to determine lag ranges

- Notebook example: [Time lag check for 2024](https://github.com/holukas/dataset_cha_fp2024_2005-2023/blob/main/notebooks/00_L0_checks/02_L0_timelags_check.ipynb)
- The lag between turbulent departures of wind and the gas of interest was first determined in a relatively wide time window (called OPENLAG run:  )
    - **IRGA** OPENLAG time window: between `-1s` and `+10s`. For IRGA, the goal was to find an appropriate nominal time lag, and to determine a time window for lag search as narrow as possible.
    - **QCL** OPENLAG time window: between `-1s` and `+10s`, and a second OPENLAG run between `-1s` and `+5s`. The second OPENLAG run was done because the first run showed that the time lags accumulated in a narrower range below +5s. For QCL fluxes, constant time lags were used for the final flux calcs, so here in the OPENLAG runs it was very important to get the value for the constant lag as correct as possible. The final lag range was then set according to these narrower results.
- The value `-1s` was used as the starting value for the time window because EddyPro had issues with a start value of `0s`, in that case the lag search started e.g. at +1s for some reason (maybe bug)
- The results from the OPENLAG runs were used to define a time window as narrow as possible (IRGA) for the final flux calculations (Level-1)
    - The histograms of found OPENLAG time lags were inspected to determine whether there was a the histogram bin with peak distribution
    - **IRGA**: peak of distribution was used as nominal (default) lag, time ranges around this peak were used as time window, [see table](https://www.swissfluxnet.ethz.ch/index.php/documentation/ch-cha-fp2025-2005-2024/#Table_EC1_IRGA_lag_ranges_seconds_for_CO2_and_H2O_LE_used_in_final_flux_calculations)
    - **QCL**: peak of distrubution was used as constant lag for the respective time period, no time window used, all lags were constant, [see table](https://www.swissfluxnet.ethz.ch/index.php/documentation/ch-cha-fp2025-2005-2024/#Table_EC2_QCL_and_LGR_constant_time_lags_seconds_for_N2O_and_CH4_used_in_final_flux_calculations)

## Check wind direction across years

I compared histograms of wind directions between 2005 and 2024 using Level-0 fluxes and found that a sonic orientation of 7° offset to north yields very similar results across years. It is therefore possible the the sonic orientation across all years was always close to 7°.

Here are results from a comparison of annual wind direction histograms (with bin width of 1°) to a reference period (2006-2009), all wind directions were calculated with a north offset of 7°, then a histogram was calculated for each year. The OFFSET describes how many degrees have to be added (or subtracted) to the half-hourly wind direction to yield a histogram that is most similar to the reference. All OFFSETS are small, which indicates that the wind directions are in good agreement.

###### **Table EC2**. QCL and LGR constant time lags (seconds) for N<sub>2</sub>O and CH4 used in final flux calculations.

|   |   |   |   |   |
|---|---|---|---|---|
|**time period**|**N2O QCL LGR**|**CH4 QCL LGR**|**H2O QCL LGR**|**Notes**|
|**2012_X**|0.85, 0.70-1.50|0.85, 0.70-1.50|1.30, 1.00-3.00|first time period QCL|
|**2013_X**|1.15, 0.85-1.70|1.10, 0.85-1.80|2.10, 1.30-3.30||
|**2014_X**|1.25, 0.95-1.60|1.15, 0.90-1.80|2.00, 1.30-3.30||
|**2015_X**|1.35, 0.70-2.00|1.25, 0.70-2.00|1.95, 1.20-4.00||
|**2016_2**|0.85, 0.65-2.00|1.00, 0.60-2.00|2.45, 1.80-4.50||
|**2016_1+3_2017_1+2**|1.15, 0.70-1.95|0.95, 0.70-2.00|1.95, 1.50-3.30|2017_1+2: no H2O lag visible|
|**2017_3_2018_1**|1.60, 1.20-2.35|1.65, 1.10-2.45|2.50, 1.50-4.00|only few data, no H2O lag visible|
|**2018_2**|n.a.|n.a.|n.a.|2018_2: no data for QCL|
|**2018_3**|2.00, 1.25-2.55|2.05, 1.25-2.55|4.45, 4.00-6.00|no H2O lag visible|
|**2018_4_2019_1+3**|1.45, 1.00-2.50|1.25, 1.00-2.50|n.a.|no H2O|
|**2019_2**|6.30, 4.00-10.00|6.80, 4.00-10.00|n.a.|not clear in Mar and Apr; no H2O|
|**2019_4**|1.55, 0.90-2.35|1.35, 0.90-2.20|n.a.|no H2O|
|**2019_5**|1.35, 1.00-2.50|1.30, 1.00-2.50|n.a.|no H2O|
|**2020_1+2**|1.45, 1.00-2.50|1.55, 1.00-2.50|n.a.|no H2O|
|**2020_3**|0.70, 0.40-0.90|0.65, 0.45-0.90|n.a.|no H2O|
|**2020_4+5_2021_1**|0.60, 0.40-0.90|0.65, 0.45-0.90|0.70, 0.60-2.00|last time period QCL, H2O available again since 2020_4|
|**2021_2_2022_1**|1.75, 1.50-3.30|1.75, 1.50-3.30|1.80, 1.65-6.00|LGR, lag fluctuates within these ranges|


