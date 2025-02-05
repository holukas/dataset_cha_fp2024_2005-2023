## Preparing the meteo data for EddyPro
- 2005-2020: we have good meteo data (already gap-filled) from the FLUXNET WW2020 dataset
- using that data for the preparation of the input file for final flux calcs (Level-1) in EddyPro 
- 6 meteo variables required for input file: `SW_IN`, `PPFD`, `TA`, `PA`, `LW_IN` and `RH`

### 2005-2020: using data from FLUXNET
- data from the [FLUXNET Warm Winter 2020](https://www.icos-cp.eu/data-products/2G60-ZHAK) dataset


#### Info about variables shared for the FLUXNET dataset
- Info from the BADM file `CH-CHA_BADM-Instrument_Ops_20190418.xlsx`

##### Table MD1. Details for variables shared with FLUXNET.

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

#### Used FLUXNET output variables for futher processing
- FLUXNET produces gap-filled variables (suffix `_F`, using MDS and ERA):
	- using `TA_F` for flux calcs in EddyPro
	- using `SW_IN_F` for flux calcs in EddyPro
	- using `LW_IN_F` for flux calcs in EddyPro
	- using `PA_F` for flux calcs in EddyPro (stored in kPa)
	- using `RH` for flux calcs in EddyPro (no gap-filled version produced by FLUXNET)
	- using `PPFD_IN` for flux calcs in EddyPro (no gap-filled version produced by FLUXNET)

