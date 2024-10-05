import matplotlib.gridspec as gridspec
import matplotlib.pyplot as plt
import matplotlib.transforms as transforms
import pandas as pd

from diive.core.plotting.plotfuncs import default_format
from diive.pkgs.analyses.histogram import Histogram

# pd.options.display.width = None
# pd.options.display.max_columns = None
pd.set_option('display.max_rows', 50)
pd.set_option('display.max_columns', 50)

# Gases
# gases = ['CO2', 'H2O', 'CH4', 'N2O']

# Source folders parquet
from diive.core.io.files import load_parquet

SOURCEFILE = r"F:\TMP\OE2\IRGA\merged_all_years.parquet"
# SOURCEFILE = r"F:\TMP\OE2\LGR\merged_all_years.parquet"
df = load_parquet(filepath=SOURCEFILE)

# from diive.core.io.filereader import ReadFileType
# SOURCEFILE = r"F:\CURRENT\CHA\FP2024.1\2012_2\2-FLUXRUN\CH-CHA_FR-20240711-204314\2-0_eddypro_flux_calculations\results\eddypro_CH-CHA_FR-20240711-204314_fluxnet_2024-07-12T161215_adv.csv"
# d = ReadFileType(filepath=SOURCEFILE, filetype='EDDYPRO-FLUXNET-CSV-30MIN', output_middle_timestamp=True)
# _df, _meta = d.get_filedata()

# print(df)

tlag_cols = [c for c in df.columns if "TLAG" in c]

# print(tlag_actual_cols)

# # Check min lags
# tlag_min_cols = [c for c in tlag_cols if c.endswith("_MIN")]
# tlag_min = df[tlag_min_cols].copy()
# for c in tlag_min.columns:
#     tlag_min[c].plot(x_compat=True, title=c)
#     plt.show()
#
# # Check max lags
# tlag_max_cols = [c for c in tlag_cols if c.endswith("_MAX")]
# tlag_max = df[tlag_max_cols].copy()
# for c in tlag_max.columns:
#     tlag_max[c].plot(x_compat=True, title=c)
#     plt.show()

tlag_actual_cols = [c for c in tlag_cols if c.endswith("_ACTUAL")]
# locs = (df.index.year == 2019) & (df.index.month >= 5)
# locs = df.index.year == 2017
# locs = (df.index.year == 2017) | (df.index.year == 2018)
# locs = (df.index.year == 2017) & (df.index < "2017-03-15 23:59:00")
# locs = (df.index.year == 2019) & ((df.index > "2019-02-17 23:59:00") & (df.index <= "2019-04-30 23:59:00"))
# locs = (
#         ((df.index > "2019-01-01 23:59:00") & (df.index < "2019-02-18 07:00:00")) |
#         ((df.index > "2019-05-01 07:00:00") & (df.index < "2019-05-22 07:00:00"))
# )
locs = (df.index > "2021-09-01 23:59:00") & (df.index < "2023-09-30 07:00:00")
# locs = (df.index > "2021-07-23 23:59:00")
tlag_actual = df[tlag_actual_cols][locs].copy()
# tlag_actual = df[tlag_actual_cols].copy()
first_date = tlag_actual.index[0].date()
last_date = tlag_actual.index[-1].date()

# for c in tlag_actual.columns:
#     tlag_actual[c].plot(x_compat=True, title=c)
#     plt.show()

gases = ['CO2']
# gases = ['CO2', 'H2O']
# vline1 = 0.05
# vline2 = 0.4
# gases = ['CH4', 'N2O']
# gases = ['CH4', 'N2O', 'H2O']
vline1 = 1.25
vline2 = 1.4
startbin = 0
endbin = 2

for gas in gases:
    gascol = f'{gas}_TLAG_ACTUAL'
    series = tlag_actual[gascol].copy()

    hist = Histogram(
        s=series,
        method='uniques',
        # n_bins=10,
        # ignore_fringe_bins=None
        ignore_fringe_bins=[5, 10]
    )

    results = hist.results
    peakbins = hist.peakbins

    locs = (results['BIN_START_INCL'] >= startbin) & (results['BIN_START_INCL'] <= endbin)
    results = results[locs].copy()

    gs = gridspec.GridSpec(1, 1)  # rows, cols
    gs.update(wspace=0.3, hspace=0.3, left=0.03, right=0.97, top=0.97, bottom=0.03)

    fig = plt.figure(layout="constrained", facecolor='white', figsize=(16, 9))
    gs = gridspec.GridSpec(2, 1, figure=fig)  # rows, cols
    ax = fig.add_subplot(gs[0, :])
    ax2 = fig.add_subplot(gs[1, :])

    hist_bins = results['BIN_START_INCL'].copy()
    hist_counts = results['COUNTS'].copy()
    bar_width = (hist_bins[1] - hist_bins[0]) * 1  # Calculate bar width
    args = dict(width=bar_width, align='edge')
    ax.bar(x=hist_bins, height=hist_counts, label='counts', zorder=90, color='#78909c', **args)
    # ax.set_xlim(hist_bins[0], hist_bins[-1])

    ax2.plot(series.index, series, alpha=0.5, c='#5f87ae', marker='.', ms=5, ls='none')

    title = f"{gascol} (between {first_date} and {last_date})"
    ax.set_title(title, fontsize=24, weight='bold')

    ax.axvline(vline1, color="blue")
    ax.axvline(vline2, color="red")
    ax2.axhline(vline1, color="blue")
    ax2.axhline(vline2, color="red")
    peak = peakbins[0]
    ax2.axhline(peak, color="black")

    trans = transforms.blended_transform_factory(ax.transData, ax.transAxes)
    ax.text(vline1, 0.70, f"start {vline1}s",
            size=16, color='blue', backgroundcolor='none', transform=trans,
            alpha=1, horizontalalignment='right', verticalalignment='top', zorder=999)
    ax.text(vline2, 0.70, f"end {vline2}s",
            size=16, color='red', backgroundcolor='none', transform=trans,
            alpha=1, horizontalalignment='left', verticalalignment='top', zorder=999)

    ax.axvline(peak, color="black")
    ax.text(peak, 0.98, f"PEAK {peak}s",
            size=16, color='black', backgroundcolor='none', transform=trans,
            alpha=1, horizontalalignment='center', verticalalignment='top', zorder=999)

    default_format(ax=ax, ax_xlabel_txt="lag (seconds)", ax_ylabel_txt="counts")
    default_format(ax=ax2, ax_xlabel_txt="date", ax_ylabel_txt="lag (s)")
    ax.locator_params(axis='both', nbins=20)
    ax2.locator_params(axis='both', nbins=20)

    fig.show()
