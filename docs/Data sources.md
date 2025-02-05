# Meteo data
- TODO
# Management data

- [Management notebook on GitHub](https://github.com/holukas/dataset_cha_fp2024_2005-2023/blob/main/notebooks/20_MANAGEMENT/22.0_ConvertMgmtToTimeseries_Correction.ipynb)
- TODO: ADD EXCEL FILE

Detailed management data are available in an Excel file. The file contains info between 2001 and 2024, whereby info for 2024 and some info for 2023 (e.g., C content of fertilizer) was not available yet. Key information was converted to a time series format with the aim to be used e.g. in machine-learning models.

## Unique events

Each management event was assigned a variable name and a list of unique events was assembled. In total, we identified 34 unique managmement events ([Table M1](https://www.swissfluxnet.ethz.ch/index.php/documentation/ch-cha-fp2024-2005-2023/#Table_M1_Unique_management_events_between_2001_and_2024)).

## Simplified variable names

Unique events were simplified and grouped together, where appropriate. In addition, the parcel info was added to the variable names. We identified 14 events that were relevant for either parcel A or parcel B ([Table M2](https://www.swissfluxnet.ethz.ch/index.php/documentation/ch-cha-fp2024-2005-2023/#Table_M2_Simplified_and_grouped_management_variables)).

## Converting management info to time series format

### Daily time scale

In order to convert `start` and `end` information for each event to time series format, an empty dataframe with _daily_ time resolution was created. Since the management info goes back to 2001, the timestamp of the dataframe was extended. As such, the first timestamp was `2001-01-01`, the last timestamp `2023-12-31`.

The info from the Excel file was then inserted into the empty dataframe. When management took place, values in the respective data column for the respective day(s) were set to `1`, otherwise to `0`. All values of the respective days of management were set to `1` because the exact starting and end times were not available for all events.


> **Example**
> The event `MGMT_GRAZING_PARCEL-B` had the start date `2008-11-01` and the end date `2008-11-04`. In the dataframe, `1` was inserted in the column `MGMT_GRAZING_PARCEL-B` between the (daily) timestamps `2008-11-01` and `2008-11-04` (inclusive start and end dates).  
 
For all management events, `TIMESINCE` variables were calculated, describing the temporal distance of each day to the previous management event.

TODO: add figure

> **Example**  
> The event `MGMT_GRAZING_PARCEL-B` had the start date `2008-11-01` and the end date `2008-11-04`. The variable `TIMESINCE_MGMT_GRAZING_PARCEL-B` was calculated and has value `0` between `2008-11-01` and `2008-11-04`, value `1` on `2008-11-05`, value `2` on `2008-11-06`, etc...  
### Half-hourly time scale

Flux and meteo data are available with a **half-hourly (hh)** timestamp. Therefore, the daily management dataframe was converted to hh time resolution. The hh timestamp shows the _middle_ of the averaging interval, `TIMESTAMP_MIDDLE`.

> **Example**  
> At the daily scale, the event `MGMT_GRAZING_PARCEL-B` had the start date `2008-11-01` and the end date `2008-11-04`. Converted to the half-hourly timescale, all values between `2008-11-01 00:15:00` and `2008-11-04 23:45:00` were set to `1`.  

Wind direction was then added to the hh management data and used to create new `_FOOTPRINT` (suffix) variables. These variables contain info about the parcel from where the wind was arriving at the sensors. This means, depending on wind direction, the `_FOOTPRINT` variables can contain info from `_PARCEL-A` or `_PARCEL-B` variables.

Parcel division runs diagonally from 250° to 70°, with the measurement station at the center. In earlier years (2005-2013), the division was less clear, with the division line shifted further to the south, but an analysis in Feigenwinter et al. (2023) showed that most of the contribution to the flux footprint (>97%) came from `PARCEL-B`, north of the station.