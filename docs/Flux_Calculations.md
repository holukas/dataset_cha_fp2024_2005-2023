# Flux Calculations

## Level 0: Preliminary flux calculations

- More details can be found in the documentation of the [Flux Processing Chain](https://www.swissfluxnet.ethz.ch/index.php/data/ecosystem-fluxes/flux-processing-chain/#Step_2_Level-0_Preliminary_Flux_Calculations_With_OPENLAG_and_Other_Tests)
- Generally, preliminary flux calculations were used to check whether the flux processing works, to check the wind direction across years and to determine appropriate time windows for lag search for final flux calculations (Level-1)

### OPENLAG runs to determine lag ranges

- Notebook example: [Time lag check for 2024](https://github.com/holukas/dataset_cha_fp2024_2005-2023/blob/main/notebooks/00_L0_checks/02_L0_timelags_check.ipynb)
- The lag between turbulent departures of wind and the gas of interest was first determined in a relatively wide time window (called OPENLAG run:  )
    - **IRGA** OPENLAG time window: between `-1s` and `+10s`. For IRGA, the goal was to find an appropriate nominal time lag, and to determine a time window for lag search as narrow as possible.
    - **QCL** OPENLAG time window: between `-1s` and `+10s`, and a second OPENLAG run between `-1s` and `+5s`. The second OPENLAG run was done because the first run showed that the time lags accumulated in a narrower range below +5s. For QCL fluxes, constant time lags were used for the final flux calcs, so here in the OPENLAG runs it was very important to get the value for the constant lag as correct as possible. The final lag range was then set according to these narrower results.
- The value `-1s` was used as the starting value for the time window because EddyPro had issues with a start value of `0s`, in that case the lag search started e.g. at +1s for some reason (maybe bug)
- The results from the OPENLAG runs were used to define a time window as narrow as possible (IRGA) for the final flux calculations (Level-1)
    - The histograms of found OPENLAG time lags were inspected to determine whether there was a the histogram bin with peak distribution
    - **IRGA**: peak of distribution was used as nominal (default) lag, time ranges around this peak were used as time window (**Table EC1**)
    - **QCL**: peak of distrubution was used as constant lag for the respective time period, no time window used, all lags were constant (**Table EC2**)

##### **Table EC1**. IRGA nominal (default) time lags and size of the lag search windows for different time periods in seconds.  Used for CO2 and H2O (LE) in final flux calculations.

| **time period**    | **CO2 IRGA**    | **H2O IRGA** | **Notes**             |
| ------------------ | --------------- | ------------ | --------------------- |
| **2005_X**         | 0.20, 0.05-0.40 | same as CO2  |                       |
| **2006_X**         | 0.25, 0.05-0.40 | same as CO2  |                       |
| **2007_X**         | 0.25, 0.05-0.40 | same as CO2  |                       |
| **2008_X**         | 0.25, 0.05-0.40 | same as CO2  |                       |
| **2009_X**         | 0.25, 0.05-0.40 | same as CO2  |                       |
| **2010_X**         | 0.30, 0.05-0.50 | same as CO2  |                       |
| **2011_X**         | 0.30, 0.05-0.55 | same as CO2  |                       |
| **2012_X**         | 0.35, 0.05-0.55 | same as CO2  | first time period QCL |
| **2013_X**         | 0.30, 0.05-0.55 | same as CO2  |                       |
| **2014_X**         | 0.30, 0.05-0.55 | same as CO2  |                       |
| **2015_X**         | 0.30, 0.05-0.55 | same as CO2  |                       |
| **2016_X**         | 0.35, 0.05-0.55 | same as CO2  |                       |
| **2017_X**         | 0.30, 0.05-0.55 | same as CO2  |                       |
| **2018_1+2+3+4**   | 0.25, 0.05-0.50 | same as CO2  |                       |
| **2019_1+2+3+4+5** | 0.30, 0.05-0.45 | same as CO2  |                       |
| **2020_1+2+3+4+5** | 0.30, 0.05-0.45 | same as CO2  |                       |
| **2021_1+2**       | 0.25, 0.05-0.45 | same as CO2  |                       |
| **2022_1+2+3**     | 0.25, 0.05-0.45 | same as CO2  |                       |
| **2023_1**         | 0.30, 0.05-0.50 | same as CO2  |                       |
| **2024_1**         | 0.30, 0.05-0.50 | same as CO2  |                       |


##### **Table EC2**. QCL and LGR constant time lags (seconds) for N<sub>2</sub>O and CH<sub>4</sub> used in final flux calculations. In addition, the range  where most time lags were found is given.

| **time period**       | **N2O QCL LGR**  | **CH<sub>4</sub> QCL LGR**  | **H2O QCL LGR** | **Notes**                                              |
| --------------------- | ---------------- | ---------------- | --------------- | ------------------------------------------------------ |
| **2012_X**            | 0.85, 0.70-1.50  | 0.85, 0.70-1.50  | 1.30, 1.00-3.00 | first time period QCL                                  |
| **2013_X**            | 1.15, 0.85-1.70  | 1.10, 0.85-1.80  | 2.10, 1.30-3.30 |                                                        |
| **2014_X**            | 1.25, 0.95-1.60  | 1.15, 0.90-1.80  | 2.00, 1.30-3.30 |                                                        |
| **2015_X**            | 1.35, 0.70-2.00  | 1.25, 0.70-2.00  | 1.95, 1.20-4.00 |                                                        |
| **2016_2**            | 0.85, 0.65-2.00  | 1.00, 0.60-2.00  | 2.45, 1.80-4.50 |                                                        |
| **2016_1+3_2017_1+2** | 1.15, 0.70-1.95  | 0.95, 0.70-2.00  | 1.95, 1.50-3.30 | 2017_1+2: no H2O lag visible                           |
| **2017_3_2018_1**     | 1.60, 1.20-2.35  | 1.65, 1.10-2.45  | 2.50, 1.50-4.00 | only few data, no H2O lag visible                      |
| **2018_2**            | n.a.             | n.a.             | n.a.            | 2018_2: no data for QCL                                |
| **2018_3**            | 2.00, 1.25-2.55  | 2.05, 1.25-2.55  | 4.45, 4.00-6.00 | no H2O lag visible                                     |
| **2018_4_2019_1+3**   | 1.45, 1.00-2.50  | 1.25, 1.00-2.50  | n.a.            | no H2O                                                 |
| **2019_2**            | 6.30, 4.00-10.00 | 6.80, 4.00-10.00 | n.a.            | not clear in Mar and Apr; no H2O                       |
| **2019_4**            | 1.55, 0.90-2.35  | 1.35, 0.90-2.20  | n.a.            | no H2O                                                 |
| **2019_5**            | 1.35, 1.00-2.50  | 1.30, 1.00-2.50  | n.a.            | no H2O                                                 |
| **2020_1+2**          | 1.45, 1.00-2.50  | 1.55, 1.00-2.50  | n.a.            | no H2O                                                 |
| **2020_3**            | 0.70, 0.40-0.90  | 0.65, 0.45-0.90  | n.a.            | no H2O                                                 |
| **2020_4+5_2021_1**   | 0.60, 0.40-0.90  | 0.65, 0.45-0.90  | 0.70, 0.60-2.00 | last time period QCL, H2O available again since 2020_4 |
| **2021_2_2022_1**     | 1.75, 1.50-3.30  | 1.75, 1.50-3.30  | 1.80, 1.65-6.00 | LGR, lag fluctuates within these ranges                |


### Check wind direction across years

I compared histograms of wind directions between 2005 and 2024 using Level-0 fluxes and found that a sonic orientation of 7° offset to north yields very similar results across years. It is therefore possible the the sonic orientation across all years was always close to 7°.

Here are results from a comparison of annual wind direction histograms (with bin width of 1°) to a reference period (2006-2009), all wind directions were calculated with a north offset of 7°, then a histogram was calculated for each year. The OFFSET describes how many degrees have to be added (or subtracted) to the half-hourly wind direction to yield a histogram that is most similar to the reference. All OFFSETS are small, which indicates that the wind directions are in good agreement.

##### **Table EC3**. Wind direction offsets (in degrees) compared to a reference period (2006-2009) from Level-0 OPENLAG runs.

| **YEAR** | **OFFSET (°)** |
| -------- | -------------------- |
| **2005** | 1.0                  |
| **2006** | 0.0                  |
| **2007** | -2.0                 |
| **2008** | -2.0                 |
| **2009** | 0.0                  |
| **2010** | 2.0                  |
| **2011** | 6.0                  |
| **2012** | 1.0                  |
| **2013** | 1.0                  |
| **2014** | 1.0                  |
| **2015** | 1.0                  |
| **2016** | 3.0                  |
| **2017** | 4.0                  |
| **2018** | 1.0                  |
| **2019** | -1.0                 |
| **2020** | -1.0                 |
| **2021** | -1.0                 |
| **2022** | 1.0                  |
| **2023** | -2.0                 |
| **2024** | 1.0                  |

## Level 1: Final flux calculations

[fluxrun](https://github.com/holukas/fluxrun) v1.4.1 (using EddyPro v7.0.9) was used for all flux calculations.

### Project creation
- **Raw file format**: ASCII plain text
- **Metadata file**: Use alternative file
- **Biomet data**: Use external file
- **Metadata**:
	- **Timestamp refers to**: Beginning of dataset period
	- **File duration**: 360 min
	- **Acquisition frequency**: 20 Hz
	- **Canopy height**: 0.50 m (constant across all years, dynamic canopy height was not available for most years)
	- **Displacement height**: 0.40 m
	- **Roughness length**: 0.08 m
	- **Altitude**: 393 m
	- **Latitude**: 47° 12' 36.799'' N
	- **Longitude**: 008° 24' 38.300'' E
	- **Example for instrument settings from 2022**:
		- **Anemometer**: Gill R3-50, Height: 2.41 m, Wind data format: U, V & W, North alignment: Axis, North off-set: 7.0°
		- **Gas Analyzers**:
			- **LI-7500 IRGA**: Northward separation: 4.00 cm, Eastward separation: 35.00 cm, Vertical separation: -1.00 cm
			- **LGR** (Los Gatos Laser, Generic Closed Path): Northward separation: 0 cm, Eastward separation: -5.00 cm, Vertical separation: -18.00 cm, Tube length: 954 cm, Tube inner diameter: 10.0 mm, Nominal tube flow rate: 8.0 l/m, Longitudinal path length: 28.00 cm, Transversal path length: 4.4450 cm, Time response: 0.1 s
	- **Raw File Description**:
		- Original raw data files were converted from an irregular compressed binary format to a regular ASCII format using [bico](https://github.com/holukas/bico)
		- **Field separator**: Comma
		- **Number of header rows**: 3
		- Columns were defined depending on the year or time period
		- ASCII files contained data for (in order): sonic anemometer, IRGA and QCL or LGR (if available)

### Basic settings
- **Files Info**: this section in EddyPro was handled by [fluxrun](https://github.com/holukas/fluxrun)
- **Missing samples allowance**: 10%
- **Flux averaging interval**: 30 min
- **North reference**: Use magnetic north
- **Master anemometer**: R3-50
- **Gas measurements**:
	- CO2: using IRGA mole fraction for fluxes
	- H2O: IRGA mole fraction (used as main flux), for some periods QCL/LGR mole fractions (only used as auxiliary flux)
	- N2O: QCL/LGR mixing ratio
	- CH4: QCL/LGR mixing ratio
- **Cell measurements**:
	- Average Cell Temperature: from QCL/LGR
	- Cell Pressure: from QCL/LGR
- **Ambient measurements**:
	- used data from external biomet data file
- **Diagnostic measurements**:
	- Not directly used since the diagnostic value was only available for newer years. However, the AGC (automatic gain control, a measure of signal quality/strength) was used in all years.

### Advanced settings
- **Angle-of-attack correction**: NO, has a tendency to overestimate CO2 uptake
- **Axis rotations for tilt correction**: Double rotation
- **Turbulent fluctuations**: 
	- Detrend method: Block average
	- Time lag compensation:
		- IRGA: Covariance maximization with default (see Table EC1)
		- QCL/LGR: Constant (see Table EC2)
- **Compensate density fluctiations (WPL terms)**: YES for open-path IRGA, NO for QCL/LGR
- **Add instrument sensible heat components for LI-7500**: NO
- **Quality check**: Mauder and Foken (2004) (0-1-2 system) for Level-1 quality flags, later extended in post-processing
- **Footprint estimation**: Kljun et al. (2004)
- **Statistical analyses**: all tests were selected for output, but not all tests were later used. Notable difference to default settings: Angle of attack criteria were slightly relaxed and allowed minimum AoA -35° (instead of default -30°) and maximum AoA +35° (instead of default +35°)
- **Random flux uncertainty**: Finkelstein and Sims (2001, Definition of the ITS: Cross-correlation first corssing 1/e, Maximum correlation period: 10s)
- **Spectral Analysis** and Corrections:
	- TODO

### Note about instrument sensible heat components for LI-7500

The application of the self-heating correction without concurrent parallel measurements with a (en-)closed path IRGA at the same site is risky because it would constitute a “blackbox” approach, i.e., we cannot know the validity of the correction. The correction is originally meant for cold ecosystems and there in particular for time periods with air temperatures < -10°C, which is rarely the case at CH-CHA. From the EddyPro help:

> “_When CO2 and H2O molar densities are measured with the an LI‑7500 in cold environments (low temperatures below -10 °C), a correction should be applied to account for the additional instrument-related sensible heat flux, due to instrument surface heating/cooling._”

In addition, Burba 2008 considers vertically mounted IRGAs only, while the IRGA at CH-CHA (and all other Swiss FluxNet sites) are tilted. The correction does not account for this tilting angle.

We are careful applying this correction for CH-CHA because we found that the correction was not working as expected for other site in Swiss FluxNet. For example, the cropland CH-OE2 ([link](https://www.swissfluxnet.ethz.ch/index.php/sites/ch-oe2-oensingen/site-info-ch-oe2/)) is at 452 m a.s.l. and climatic conditions (air temperatures) are very similar to CH-CHA. For CH-OE2, had the option to compare fluxes from the open-path IRGA LI-7500 (LI75) with concurrent fluxes from the enclosed-path IRGA LI-7200 (LI72). We found that LI75 and LI72 fluxes corresponded relatively well over approx. 2 years (Fig. 1, LI75 in red, LI72 as “true” flux in black). However, when we corrected the LI75 fluxes using EddyPro (Burba 2008 method) we found that the correction resulted in a strong underestimation of the cumulative carbon uptake in comparison to LI72 (see blue and purple lines). This indicates that the default application of the Burba 2008 correction is risky.

![](../images/self-heating_CH-OE2_cropland_2015-2017.png)
**Figure 1**. Cumulative NEE fluxes from Feb 2015 until Apr 2017 at the cropland site CH-OE2. Shown is a comparison of self-heating correction approaches: open-path LI-7500 fluxes (only WPL corrected, red) with enclosed-path LI-7200 fluxes (black, assumed to show the “true” flux). Also shown are cumulative fluxes after applying the Burba 2008 correction in EddyPro using the single linear regression method (SLR, blue) and the multiple regression method (MLR, purple).

In contrast, for the forest site CH-LAE ([link](https://www.swissfluxnet.ethz.ch/index.php/sites/ch-lae-laegeren/site-info-ch-lae/)) we found that some self-heating correction is clearly needed, even in summer when temperature increase > 30°C. Here, the Burba 2008 correction yields unsatisfactory results and corrects the fluxes only slightly, albeit in the right direction (Fig. 2). CH-LAE has a relatively unique location and is very different from CH-CHA. For CH-LAE, we apply the self-heating correction similar to Kittler et al. (2017, [link](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/2017JG003830)), which used an earlier description of the correction (Burba 2006) in combination with a scaling factor. A more detailed description for the CH-LAE correction can be found here: [link](https://www.swissfluxnet.ethz.ch/index.php/knowledge-base/ch-lae-fp2021-2004-2020/#Note_Self-heating_correction_of_open-path_CO2_fluxes). Unfortunately, at CH-CHA we cannot apply this method since parallel measurements are not available.

![](../images/self-heating_CH-LAE_mixedForest_2016-2017.png)
**Figure 2**. Cumulative NEE between Jan 2016 and Dec 2017 at the forest site CH-LAE. “True” flux from LI-7200 (black), no self-heating correction for LI-7500 fluxes (red), after correction in EddyPro Burba 2008 (blue) and after correction Kittler 2017 (orange).


The self-heating issue for open-path IRGAs is still not solved and we know of three publications currently in preparation (one from this group) addressing this issue. Due to the reasons outlined above and the involved uncertainties we currently refrain from applying the correction to CH-CHA fluxes.

---

Without parallel measurements it is not possible to quantify the uncertainty related to IRGA self-heating. The correction proposed by Burba et al. (2008) was developed based on a relatively short dataset from few sites with vertically-mounted IRGAs. Applying this correction to data from the inclined-mounted IRGA from CH-CHA would need knowledge about the fraction (ξ, scaling term) of the correction that is needed at this specific site. The fraction must be determined empirically and can range from 0 (no self-heating effect) to 1 (full self-heating correction). Examples for the empirically detected fraction term are e.g. 0.05 for grasslands (Rogiers et al., 2008) and e.g. 0.06 for urban, 0.085 for forest environments (Järvi et al., 2009). It was previously reported that ξ can be extremely small (0.005 – 0.015) even for arctic ecosystems where ξ is expected to be higher than in moderate climates (Holl et al., 2019). Kittler et al. (2017) showed that different ξ values are needed for daytime and nighttime data (empirically determined from parallel measurements). Our own research into this issue revealed an even more complex picture: we found that ξ, determined from parallel measurements, can vary significantly over the course of one day._ **_Figure 3_** _shows ξ for the forest site CH-LAE and demonstrates that ξ is mostly 0.05 during the night (i.e. the night fluxes need a 5% self-heating correction), but increases during sunrise, reaching values of up to 0.3. In contrast, ξ for the forest site CH-DAV showed a completely different picture._ **_Figure_** **_4_** _shows that high values for ξ are needed during the night, but ξ is close to zero during the day (i.e. daytime fluxes need little correction). The central finding of_ **_Figure 3_** _and_ **_Figure 4_** _is that ξ is not constant and applying an unknown constant ξ to fluxes where parallel measurements were not available would yield “corrected” fluxes of unknown quality. In the absence of parallel measurements, ξ remains unknown. Unfortunately, there is no general ξ value that can be used with confidence across sites or for specific ecosystems. A recent study recommended against applying the fitting correction with coefficients for other sites (Deventer et al., 2021).

It was shown previously that the self-heating effect can be negligible at grasslands (e.g. Haslwanter et al, 2009, see their Fig. 2; AT-Neu) and that the self-heating correction can produce fluxes that are far away from the “true” flux (Wohlfahrt et al, 2008, see their Fig. 3). The observation that the correction can produce fluxes that are worse than uncorrected fluxes is in line with our observations: we already showed in our previous response how a blackbox application of the correction can produce fluxes that are far away from the “true” flux from a closed-path system at our cropland site CH-OE2.

Due to the points raised we – and many other sites using the LI-COR LI-7500 – are currently not in a position to determine the flux uncertainty due to IRGA self-heating, which is unfortunate. A blackbox application of available corrections is risky, as the study by Deventer et al. (2021) points out: the use of current self-heating corrections in the absence of parallel reference flux measurements “[…] yields uncertainties that are larger than random flux errors—substantially degrading confidence in ecosystem carbon[…]budgets”.



##### **Table EC4**: Level-1 files IRGA (2005-2024).

| Used Level-1 files.         |
| ------------------------------------------------------------------------------------------ |
| 2005_1_IRGA_eddypro_CH-CHA_FR-20240730-112428_fluxnet_2024-07-30T182651_adv.csv         |
| 2006_1_IRGA_eddypro_CH-CHA_FR-20240730-112420_fluxnet_2024-07-31T080813_adv.csv         |
| 2007_1_IRGA_eddypro_CH-CHA_FR-20240730-112410_fluxnet_2024-07-31T064739_adv.csv         |
| 2008_1_IRGA_eddypro_CH-CHA_FR-20240730-112401_fluxnet_2024-07-31T085214_adv.csv         |
| 2009_1+3_eddypro_CH-CHA_FR-20240919-144235_fluxnet_2024-09-20T054007_adv.csv            |
| 2009_2_eddypro_CH-CHA_FR-20240919-144503_fluxnet_2024-09-19T181458_adv.csv              |
| 2010_1+3_IRGA_eddypro_CH-CHA_FR-20240728-190324_fluxnet_2024-07-29T140100_adv.csv       |
| 2010_2_IRGA_eddypro_CH-CHA_FR-20240730-112352_fluxnet_2024-07-30T160648_adv.csv         |
| 2011_1_IRGA_eddypro_CH-CHA_FR-20240728-190344_fluxnet_2024-07-29T153514_adv.csv         |
| 2012_1_IRGA_eddypro_CH-CHA_FR-20240730-112342_fluxnet_2024-07-30T134628_adv.csv         |
| 2012_2_IRGA_eddypro_CH-CHA_FR-20240728-190409_fluxnet_2024-07-29T165401_adv.csv         |
| 2013_1_IRGA_eddypro_CH-CHA_FR-20240727-210036_fluxnet_2024-07-29T001913_adv.csv         |
| 2014_1_IRGA_eddypro_CH-CHA_FR-20240727-210133_fluxnet_2024-07-29T001656_adv.csv         |
| 2015_1_IRGA_eddypro_CH-CHA_FR-20240727-210058_fluxnet_2024-07-28T091257_adv.csv         |
| 2015_2_IRGA_eddypro_CH-CHA_FR-20240727-210122_fluxnet_2024-07-28T151141_adv.csv         |
| 2016_1+3_IRGA_eddypro_CH-CHA_FR-20240730-112331_fluxnet_2024-07-31T065812_adv.csv       |
| 2016_2_IRGA_eddypro_CH-CHA_FR-20240730-112320_fluxnet_2024-07-30T165223_adv.csv         |
| 2017_1+2+3_IRGA_eddypro_CH-CHA_FR-20240727-210107_fluxnet_2024-07-29T012549_adv.csv     |
| 2018_1+2_IRGA_eddypro_CH-CHA_FR-20240727-210213_fluxnet_2024-07-28T230450_adv.csv       |
| 2018_3_IRGA_eddypro_CH-CHA_FR-20240730-112310_fluxnet_2024-07-30T132817_adv.csv         |
| 2018_4_IRGA_eddypro_CH-CHA_FR-20240730-112301_fluxnet_2024-07-30T144534_adv.csv         |
| 2019_1+2+3+4+5_IRGA_eddypro_CH-CHA_FR-20240727-210200_fluxnet_2024-07-29T014548_adv.csv |
| 2020_1+2+3_IRGA_eddypro_CH-CHA_FR-20240727-210028_fluxnet_2024-07-28T094044_adv.csv     |
| 2020_4_IRGA_eddypro_CH-CHA_FR-20240730-112251_fluxnet_2024-07-30T121132_adv.csv         |
| 2020_5_IRGA_eddypro_CH-CHA_FR-20240727-210053_fluxnet_2024-07-28T161420_adv.csv         |
| 2021_1_IRGA_eddypro_CH-CHA_FR-20240727-005940_fluxnet_2024-07-27T135432_adv.csv         |
| 2021_2_IRGA_eddypro_CH-CHA_FR-20240727-010348_fluxnet_2024-07-27T120109_adv.csv         |
| 2022_1+2_IRGA_eddypro_CH-CHA_FR-20240726-181747_fluxnet_2024-07-27T080504_adv.csv       |
| 2022_3_IRGA_eddypro_CH-CHA_FR-20240726-181749_fluxnet_2024-07-27T051830_adv.csv         |
| 2023_1_IRGA_eddypro_CH-CHA_FR-20240726-181748_fluxnet_2024-07-27T162051_adv.csv         |
| 2024_IRGA_eddypro_CH-CHA_FR-20250124-134851_fluxnet_2025-01-25T080153_adv.csv           |

