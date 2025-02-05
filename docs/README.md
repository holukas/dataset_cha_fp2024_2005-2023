
# CH-CHA Flux Product
Version: FP2025.X

[Refe](#References)
# Links

* **Jupyter notebooks** used to create the dataset can be found here: [https://github.com/holukas/dataset\_cha\_fp2024\_2005-2023/tree/main](https://github.com/holukas/dataset_cha_fp2024_2005-2023/tree/main)
*   The notebooks used the Python library [diive](https://github.com/holukas/diive)
*   [Overview of processing progress on Google Docs](https://docs.google.com/spreadsheets/d/1KXaTtckHqOGULcr9nwL0FJ-xDnMJUFeDaXX8zh0fbJo/edit?usp=sharing) (binary conversion and Level-0 and Level-1 calculations), this sheet was used during processing
*   General overview of flux processing chain, explaining the different flux levels: [Flux Processing Chain](https://www.swissfluxnet.ethz.ch/index.php/data/ecosystem-fluxes/flux-processing-chain/)
*   Flux partitioning was done using [ReddyProc](https://github.com/EarthyScience/REddyProc) v1.3.3

# Data sources
## Meteo data
- TODO
## Management data

- [Management notebook on GitHub](https://github.com/holukas/dataset_cha_fp2024_2005-2023/blob/main/notebooks/20_MANAGEMENT/22.0_ConvertMgmtToTimeseries_Correction.ipynb)
- TODO: ADD EXCEL FILE

Detailed management data are available in an Excel file. The file contains info between 2001 and 2024, whereby info for 2024 and some info for 2023 (e.g., C content of fertilizer) was not available yet. Key information was converted to a time series format with the aim to be used e.g. in machine-learning models.

### Unique events

Each management event was assigned a variable name and a list of unique events was assembled. In total, we identified 34 unique managmement events ([Table M1](https://www.swissfluxnet.ethz.ch/index.php/documentation/ch-cha-fp2024-2005-2023/#Table_M1_Unique_management_events_between_2001_and_2024)).

### Simplified variable names

Unique events were simplified and grouped together, where appropriate. In addition, the parcel info was added to the variable names. We identified 14 events that were relevant for either parcel A or parcel B ([Table M2](https://www.swissfluxnet.ethz.ch/index.php/documentation/ch-cha-fp2024-2005-2023/#Table_M2_Simplified_and_grouped_management_variables)).

### Converting management info to time series format

#### Daily time scale

In order to convert `start` and `end` information for each event to time series format, an empty dataframe with _daily_ time resolution was created. Since the management info goes back to 2001, the timestamp of the dataframe was extended. As such, the first timestamp was `2001-01-01`, the last timestamp `2023-12-31`.

The info from the Excel file was then inserted into the empty dataframe. When management took place, values in the respective data column for the respective day(s) were set to `1`, otherwise to `0`. All values of the respective days of management were set to `1` because the exact starting and end times were not available for all events.


> **Example**
> The event `MGMT_GRAZING_PARCEL-B` had the start date `2008-11-01` and the end date `2008-11-04`. In the dataframe, `1` was inserted in the column `MGMT_GRAZING_PARCEL-B` between the (daily) timestamps `2008-11-01` and `2008-11-04` (inclusive start and end dates).  
 
For all management events, `TIMESINCE` variables were calculated, describing the temporal distance of each day to the previous management event.

TODO: add figure

> **Example**  
> The event `MGMT_GRAZING_PARCEL-B` had the start date `2008-11-01` and the end date `2008-11-04`. The variable `TIMESINCE_MGMT_GRAZING_PARCEL-B` was calculated and has value `0` between `2008-11-01` and `2008-11-04`, value `1` on `2008-11-05`, value `2` on `2008-11-06`, etc...  
#### Half-hourly time scale

Flux and meteo data are available with a **half-hourly (hh)** timestamp. Therefore, the daily management dataframe was converted to hh time resolution. The hh timestamp shows the _middle_ of the averaging interval, `TIMESTAMP_MIDDLE`.

> **Example**  
> At the daily scale, the event `MGMT_GRAZING_PARCEL-B` had the start date `2008-11-01` and the end date `2008-11-04`. Converted to the half-hourly timescale, all values between `2008-11-01 00:15:00` and `2008-11-04 23:45:00` were set to `1`.  

Wind direction was then added to the hh management data and used to create new `_FOOTPRINT` (suffix) variables. These variables contain info about the parcel from where the wind was arriving at the sensors. This means, depending on wind direction, the `_FOOTPRINT` variables can contain info from `_PARCEL-A` or `_PARCEL-B` variables.

Parcel division runs diagonally from 250° to 70°, with the measurement station at the center. In earlier years (2005-2013), the division was less clear, with the division line shifted further to the south, but an analysis in Feigenwinter et al. (2023) showed that most of the contribution to the flux footprint (>97%) came from `PARCEL-B`, north of the station.

# References

*   Keenan, T. F., Migliavacca, M., Papale, D., Baldocchi, D., Reichstein, M., Torn, M., & Wutzler, T. (2019). Widespread inhibition of daytime ecosystem respiration. _Nature Ecology & Evolution_, _3_(3), 407–415. [https://doi.org/10.1038/s41559-019-0809-2](https://doi.org/10.1038/s41559-019-0809-2)
*   Lasslop, G., Reichstein, M., Papale, D., Richardson, A. D., Arneth, A., Barr, A., Stoy, P., & Wohlfahrt, G. (2010). Separation of net ecosystem exchange into assimilation and respiration using a light response curve approach: Critical issues and global evaluation: SEPARATION OF NEE INTO GPP AND RECO. _Global Change Biology_, _16_(1), 187–208. [https://doi.org/10.1111/j.1365-2486.2009.02041.x](https://doi.org/10.1111/j.1365-2486.2009.02041.x)
*   Reichstein, M., Falge, E., Baldocchi, D., Papale, D., Aubinet, M., Berbigier, P., Bernhofer, C., Buchmann, N., Gilmanov, T., Granier, A., Grunwald, T., Havrankova, K., Ilvesniemi, H., Janous, D., Knohl, A., Laurila, T., Lohila, A., Loustau, D., Matteucci, G., … Valentini, R. (2005). On the separation of net ecosystem exchange into assimilation and ecosystem respiration: Review and improved algorithm. _Global Change Biology_, _11_(9), 1424–1439. [https://doi.org/10.1111/j.1365-2486.2005.001002.x](https://doi.org/10.1111/j.1365-2486.2005.001002.x)