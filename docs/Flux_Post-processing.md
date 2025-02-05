### Level 2: Quality flag expansion

- **Angle-of-attack (AoA) flag** was applied between `2008-01-01` and `2010-01-01`, and between `2016-03-01` and `2016-05-01`. All time periods when the flag indicated issues with AoA were flagged as bad data.
- XXX

### Level 3.1: Storage correction

- Added storage term from single point measurement to the respective flux
- Storage-corrected fluxes are: `NEE_L3.1` (from `FC`), `LE_L3.1` (from `LE`), `H_L3.1` (from `H`), `FN2O_L3.1` (from `FN2O`), `FCH4_L3.1` (from `FCH4`)
- The suffix `_L3.1` is added to all fluxes to make it clear that the respective flux is storage corrected. Only for `NEE` it is clear that it is the storage-corrected flux because the name changes from `FC` to `NEE` after the correction, but all other variables do not have such a name change, thus the suffix.

### Level 3.2: Outlier removal

- Absolute limits: XXX

### Level 3.3: USTAR filtering

- Remove fluxes during time periods of low turbulence
- Fluxes filtered with USTAR threshold: `NEE`, `FN2O`, `FCH4`
- Fluxes _not_ filtered: `LE`, `H`; see reasoning in Pastorello et al. (2020):  
    
    > The USTAR filtering is not applied to H and LE, because it has not been proved that when there are CO2 advective fluxes, these also impact energy fluxes, specifically due to the fact that when advection is in general large (nighttime), energy fluxes are small.
    
- A constant USTAR threshold (`CUT`) was used for all years (same threshold for all years)
- Threshold values are based on USTAR detection results from the most recent FLUXNET data product (2024)
- The threshold detection was done by FLUXNET, using data between 2005 and 2023 and using the method described in Pastorello et al. (2020)
- Following Pastorello et al. (2020), three USTAR scenarios were considered to calculate three NEE versions:
    - `CUT_50`: This is the main NEE version (best estimate) with a constant USTAR threshold of `0.069898`, corresponding to the 50th percentile from the FLUXNET detection results
    - `CUT_16`: NEE version with a constant USTAR threshold of `0.052945`, corresponding to the 16th percentile from the FLUXNET detection results
    - `CUT_84`: NEE version with a constant USTAR threshold of `0.092841`, corresponding to the 84th percentile from the FLUXNET detection results
    - The two other scenarios use a slightly lower and higher threshold.
- The USTAR threshold found for `NEE` was also applied to `FN2O` and `FCH4`

### Level 4.1: Gap-filling

#### Random forest

- All fluxes were gap-filled using the class `LongTermGapFillingRandomForestTS` from [diive](https://github.com/holukas/diive/tree/main)
- This class builds a random forest model for each year, trained on data of the respective year and the two closest/neighboring years
- For example: for gap-filling 2015, the model was trained on 2014, 2015 and 2016. For 2005 (the very first year for FC fluxes), the two closest years were used, i.e., the model was trained on 2005, 2006 and 2007. Likewise, for the very last year, the model was trained on data from the last year and the two preceding years.
- Features (predictors):
    - XXX

### Level 4.2: NEE Partitioning (planned)

- _in progress_
- Nighttime method based on Reichstein et al (2005)
- Daytime method based on Lasslop et al. (2010)
- Modified daytime method based on Keenan et al. (2019)