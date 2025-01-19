"""
I compared histograms of wind directions between 2005 and 2023 and found that a sonic orientation of 7° offset to north yields very similar results across years. It is therefore possible the the sonic orientation on this day was also close to 7°.

Here are results from a comparison of annual wind direction histograms (with bin width of 1°) to a reference period (2006-2009), all wind directions were calculated with a north offset of 7°, then a histogram was calculated for each year. The OFFSET describes how many degrees have to be added (or subtracted) to the half-hourly wind direction to yield a histogram that is most similar to the reference. All OFFSETS are small, which indicates that the wind directions are in good agreement.

      YEAR  OFFSET
0   2005.0     1.0
1   2006.0     0.0
2   2007.0    -2.0
3   2008.0    -2.0
4   2009.0     0.0
5   2010.0     2.0
6   2011.0     6.0
7   2012.0     1.0
8   2013.0     1.0
9   2014.0     1.0
10  2015.0    -3.0
11  2016.0     3.0
12  2017.0     4.0
13  2018.0     1.0
14  2019.0    -1.0
15  2020.0    -1.0
16  2021.0    -1.0
17  2022.0     1.0
18  2023.0    -2.0
"""

from diive.pkgs.corrections.winddiroffset import WindDirOffset

filepath = r"F:\CURRENT\CHA\FP2024.1\0-Level-0_fluxnet_2005-2023\Level-0_fluxnet_2005-2023.parquet"
from diive.core.io.files import load_parquet
df = load_parquet(filepath=filepath)

col = 'WD'
wd = df[col].copy()

# # Prepare input data
# wd = wd.loc[wd.index.year <= 2009]
# wd = wd.dropna()

wds = WindDirOffset(winddir=wd, offset_start=-50, offset_end=50, hist_ref_years=[2006, 2009], hist_n_bins=360)
yearlyoffsets_df = wds.get_yearly_offsets()
s_corrected = wds.get_corrected_wind_directions()
print(yearlyoffsets_df)
print(s_corrected)
print(wd)

from diive.core.plotting.heatmap_datetime import HeatmapDateTime
HeatmapDateTime(series=s_corrected).show()
HeatmapDateTime(series=wd).show()
