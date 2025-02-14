# Meteo Data

## Meteo data for EddyPro

**Notebook**: [12.0_DownloadMeteo_2005-2024_FLUXNET_diive_for_eddypro.ipynb](../notebooks/10_METEO/12.0_DownloadMeteo_2005-2024_FLUXNET_diive_for_eddypro.ipynb)
	- This is the notebook that was used to prepare input data for 2024 fluxes - which were calculated once 2024 was complete - and to create a new biomet file for future flux calculations. The notebook downloads meteo data from a newer FLUXNET version (v2024 dataset). However, for the flux calcs 2005-2020, meteo data from the [FLUXNET Warm Winter 2020](https://www.icos-cp.eu/data-products/2G60-ZHAK) dataset were used, which was done using an older version of this notebook (no longer available).

- 6 meteo variables required: `SW_IN`, `PPFD`, `TA`, `PA`, `LW_IN` and `RH`
- **For 2005-2020**, meteo data from the [FLUXNET Warm Winter 2020](https://www.icos-cp.eu/data-products/2G60-ZHAK)  dataset were used: 
	- `SW_IN_F`, `TA_F`, `LW_IN_F`, `PPFD_IN`, `RH` and `PA_F`
	- FLUXNET produces gap-filled variables (suffix `_F`, using MDS and ERA)
- **For 2021-2024**, newly screened data from the database were used:
	- `SW_IN_T1_2_1`, `TA_T1_2_1`, `LW_IN_T1_2_1`, `PPFD_IN_T1_2_2`, `RH_T1_2_1`, `PA_GF1_0.9_1` (stored in mbar = hPa)
	- Meteoscreening from database was done using the Python library `diive`.
	- After meteoscreening, the variables `SW_IN_T1_2_1`, `TA_T1_2_1` and `PPFD_IN_T1_2_2` were gap-filled using XGBoost as implemented in `diive`.

All 6 meteo variables were merged into one file that was then used as input file (external meteo data) in EddyPro. 

**Note#1 regarding meteo data in EddyPro output files:**
> Even though all gap-filled variables were used as input variables for EddyPro, the result files contained GAPS for the meteo variables. It seems that EddyPro only ouputs meteo variables to the results files for those records where some flux results were generated. This means that meteo variables shared with FLUXNET should be uploaded separately, and not from the EddyPro results files, otherwise numerous measured data points are not available. (2 Aug 2024)

**Note#2 regarding relative humidity:**
> For 2012 and surrounding years, there are no data for RH. The Feigenwinter et al. (2023) paper used a gap-filled variant of RH, where data from a neighboring MeteoSwiss stations was used for the missing data. The EddyPro fluxes were calculated without RH for those time periods, because the FLUXNET data for RH were used and there the gaps were not filled. I thought it might not be the best approach to use RH from another station during flux calcs, but instead let EddyPro figure it out. (2 Sep 2024)

## Meteo data for analysis

**Notebooks**: [Notebooks used to quality-screen, download, merge and gap-fill meteo data.](../notebooks/10_METEO/README.txt)

For the first version of the CH-CHA flux product (CH-CHA FP2025.1 2005-2024), the following meteo variables were available for analyses:
- `TA` `SW_IN` `LW_IN` `PA` `PPFD` `RH`, `VPD`, `SWC`, `TS`, `PRECIP`

See *Note#1* above: because of this warning I assembled the meteo data again to a new file that contains the meteo 6 variables between 2005 and 2024.

### Data sources
- **2005-2020**: Variables used from [Feigenwinter et al. (2023)](https://doi.org/10.1016/j.agrformet.2023.109613):
```
'G_0.03', 'LW_IN', 'LW_OUT', 'PA', 'PPFD_IN', 'PREC_RAIN', 'RH', 'SW_IN', 'SW_IN_SOURCE', 'SW_OUT', 'SWC_0.05', 'SWC_0.15', 'SWC_0.75', 'TA', 'TS_0.04', 'TS_0.15', 'TS_0.4'
```

```
# Variables were renamed to follow the group convention:
'G_0.03': 'G_GF1_0.03_1',
'LW_IN': 'LW_IN_T1_2_1',
'LW_OUT': 'LW_OUT_T1_2_1',
'PA': 'PA_GF1_0.9_1',
'PPFD_IN': 'PPFD_IN_T1_2_2',
'PREC_RAIN': 'PREC_RAIN_TOT_GF1_0.5_1',
'RH': 'RH_T1_2_1',
'SW_IN': 'SW_IN_T1_2_1',
'SW_OUT': 'SW_OUT_T1_2_1',
'SWC_0.05': 'SWC_GF1_0.05_1',
'SWC_0.15': 'SWC_GF1_0.15_1',
'SWC_0.75': 'SWC_GF1_0.75_1',
'TA': 'TA_T1_2_1',
'TS_0.04': 'TS_GF1_0.04_1',
'TS_0.15': 'TS_GF1_0.15_1',
'TS_0.4': 'TS_GF1_0.4_1'
```
- **2021-2023**: `PREC` from FLUXNET v2024 dataset
- **2021-2024**: Newly screened variables from the database:
```
'TA_T1_2_1', 'SW_IN_T1_2_1', 'PPFD_IN_T1_2_2', 'LW_IN_T1_2_1', 'RH_T1_2_1', 'PA_GF1_0.9_1', 'SWC_GF1_0.05_1', 'SWC_GF1_0.15_1', 'SWC_GF1_0.2_1', 'SWC_LOWRES_GF1_0.75_3', 'TS_LOWRES_GF1_0.05_3', 'TS_LOWRES_GF1_0.2_3', 'TS_LOWRES_GF1_0.4_3', 'PREC_RAIN_TOT_GF1_0.5_1' (PREC only 2024)
```
- **2005-2024**: `VPD` was newly calculated from gap-filled (XGBoost in `diive`) `TA` and `RH`

### Data merging
- All data were merged together.
- `PREC` (2005-2020) from Feigenwinter et al. (2023), FLUXNET v2024 (2021-2023) and newly screened from database (2024)
- `SWC` (2005-2020) from Feigenwinter et al. (2023) and new diive meteoscreening (2021-2024)
	- For `SWC`, some of the earlier depths were no longer available, and there was no overlap of measurements between the old and new sensors. Therefore, the most similar depths were merged. Although not perfect, this was the best option.
	- `SWC_0.05` (2005-2020) from Feigenwinter et al. (2023) was merged with `SWC_GF1_0.05_1` (2021-2024)
	- `SWC_0.15` (2005-2020) from Feigenwinter et al. (2023) was merged with `SWC_GF1_0.15_1` and `SWC_GF1_0.2_1` (2021-2024)
	- `SWC_0.75` (2005-2020) from Feigenwinter et al. (2023) was merged with `SWC_LOWRES_GF1_0.75_3` (2021-2024)
- `TS` (2005-2020) from Feigenwinter et al. (2023) and new diive meteoscreening (2021-2024)
	- There were some changes in the setup for soil temp sensors in 2020/2021 (simlar to `SWC`, see above).
	- `TS_0.04` (2005-2020) from Feigenwinter et al. (2023) was merged with `TS_LOWRES_GF1_0.05_3` (2021-2024), even though the latter one showed a higher amplitude, but it seems to be the best available for 2021 onwards.
	- `TS_0.15` (2005-2020) from Feigenwinter et al. (2023) was merged with `TS_LOWRES_GF1_0.2_3` (2021-2024), these two variables had an overlap of one year in 2020 and they looked very similar.
	- `TS_0.4` (2005-2020) from Feigenwinter et al. (2023) was merged with `TS_LOWRES_GF1_0.4_3` (2021-2024), these two variables had an overlap of one year in 2020 and they looked very similar.

### Gap-filling
- The merged data were gap-filled for some variables, using XGBoost, including lagged variants as additional features:
	- `SW_IN`, `TA`, `PPFD`, `SWC` (only `SWC_GF1_0.15_1` used because it was the most complete time series, using `PREC` and time since `PREC` as features in the model), `TS` (using `TA` for first gap-filling `TS_GF1_0.04_1`, and then using gap-filled `TS_GF1_0.04_1` for `TS_GF1_0.15_1`, and then using gap-filled `TS_GF1_0.04_1` and gap-filled `TS_GF1_0.15_1` for `TS_GF1_0.4_1`)

## Meteo data originally shared with FLUXNET

##### Table MD1. Details for variables shared with FLUXNET. 
Info from the BADM file `CH-CHA_BADM-Instrument_Ops_20190418.xlsx`

| FLUXNET VAR       |  ETH VAR          | INSTRUMENT                     |
| ------------- | ------------------------------ | ------------------------------------------------------------------------------- |
| P_1_1_1       |  P_RAIN_GF1_0x5_1_Tot          | SN: 810326.0007, LAMBRECHT meteo GmbH, P_RAIN_GF1_0x5_1_Tot                     |
| SWC_1_1_1     |  SWC_AVG_GF1_0.05_1            | Model ML2x, Delta-T Devices Ltd, Cambridge, United Kingdom, SWC_AVG_GF1_0.05_1  |
| SWC_1_2_1     |  SWC_AVG_GF1_0.15_1            | Model ML2x, Delta-T Devices Ltd, Cambridge, United Kingdom, SWC_AVG_GF1_0.15_1  |
| SWC_1_3_1     |  SWC_AVG_GF1_0.75_1            | Model ML2x, Delta-T Devices Ltd, Cambridge, United Kingdom, SWC_AVG_GF1_0.75_1  |
| TS_1_1_1      |  TS_AVG_GF1_0.01_1             | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.01_1                 |
| TS_1_2_1      |  TS_AVG_GF1_0.04_1             | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.04_1                 |
| TS_1_3_1      |  TS_AVG_GF1_0.07_1             | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.07_1                 |
| TS_1_4_1      |  TS_AVG_GF1_0.1_1              | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.1_1                  |
| TS_1_5_1      |  TS_AVG_GF1_0.15_1             | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.15_1                 |
| TS_1_6_1      |  TS_AVG_GF1_0.25_1             | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.25_1                 |
| TS_1_7_1      |  TS_AVG_GF1_0.4_1              | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.4_1                  |
| TS_1_8_1      |  TS_AVG_GF1_0.95_1             | Model TL107, Markasub AG, Olten, Switzerland, TS_AVG_GF1_0.95_1                 |
| SWC_1_4_1     |  SWC_AVG_GF1_0.05_2            | 5TM, former Decagon Devices, Inc., today METER Group, SWC_AVG_GF1_0.05_2        |
| SWC_1_5_1     |  SWC_AVG_GF1_0.1_2             | 5TM, former Decagon Devices, Inc., today METER Group, SWC_AVG_GF1_0.1_2         |
| SWC_1_6_1     |  SWC_AVG_GF1_0.2_2             | 5TM, former Decagon Devices, Inc., today METER Group, SWC_AVG_GF1_0.2_2         |
| SWC_1_7_1     |  SWC_AVG_GF1_0.3_2             | 5TM, former Decagon Devices, Inc., today METER Group, SWC_AVG_GF1_0.3_2         |
| SWC_1_8_1     |  SWC_AVG_GF1_0.5_2             | 5TM, former Decagon Devices, Inc., today METER Group, SWC_AVG_GF1_0.5_2         |
| TS_1_9_1      |  TS_AVG_GF1_0.025_2            | CS109 Temperature probe, Campbell Scientific, Logan UT, USA, TS_AVG_GF1_0.025_2 |
| TS_1_10_1     |  TS_AVG_GF1_0.05_2             | 5TM, former Decagon Devices, Inc., today METER Group, TS_AVG_GF1_0.05_2         |
| TS_1_11_1     |  TS_AVG_GF1_0.1_2              | 5TM, former Decagon Devices, Inc., today METER Group, TS_AVG_GF1_0.1_2          |
| TS_1_12_1     |  TS_AVG_GF1_0.2_2              | 5TM, former Decagon Devices, Inc., today METER Group, TS_AVG_GF1_0.2_2          |
| TS_1_13_1     |  TS_AVG_GF1_0.3_2              | 5TM, former Decagon Devices, Inc., today METER Group, TS_AVG_GF1_0.3_2          |
| TS_1_14_1     |  TS_AVG_GF1_0.5_2              | 5TM, former Decagon Devices, Inc., today METER Group, TS_AVG_GF1_0.5_2          |
| Ta_1_1_1      | TA_AVG_T1_2_1                  |                                                                                 |
| Pa_1_1_1      | PA_AVG_GF1_0.9_1               |                                                                                 |
| RH_1_1_1      | RH_AVG_SCALED_T1_2_1           |                                                                                 |
| SW_IN_1_1_1   | SW_IN_CORRECTED_AVG_T1B2_2_1   |                                                                                 |
| LW_IN_1_1_1   | LW_IN_AVG_T1B2_2_1             |                                                                                 |
| PPFD_IN_1_1_1 | PPFD_IN_CORRECTED_AVG_T1B2_2_2 |                                                                                 |




