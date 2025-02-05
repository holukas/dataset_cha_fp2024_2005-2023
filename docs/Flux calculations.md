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

###### **Table EC3**. Wind direction offsets (in degrees) compared to a reference period (2006-2009) from Level-0 OPENLAG runs.

| **YEAR**   | **OFFSET (°)  <br>** |
| ---------- | -------------------- |
| **2005.0** | 1.0                  |
| **2006.0** | 0.0                  |
| **2007.0** | -2.0                 |
| **2008.0** | -2.0                 |
| **2009.0** | 0.0                  |
| **2010.0** | 2.0                  |
| **2011.0** | 6.0                  |
| **2012.0** | 1.0                  |
| **2013.0** | 1.0                  |
| **2014.0** | 1.0                  |
| **2015.0** | 1.0                  |
| **2016.0** | 3.0                  |
| **2017.0** | 4.0                  |
| **2018.0** | 1.0                  |
| **2019.0** | -1.0                 |
| **2020.0** | -1.0                 |
| **2021.0** | -1.0                 |
| **2022.0** | 1.0                  |
| **2023.0** | -2.0                 |
| **2024.0** | 1.0                  |
