
from diive.core.io.filereader import search_files, MultiDataFileReader, ReadFileType
from pathlib import Path

# Source folders
SOURCEDIR = r"F:\CURRENT\CHA\FP2024.1\0-Level-0_fluxnet_2005-2023"
SOURCEFILE = r"eddypro_CH-CHA_FR-20240708-211727_fluxnet_2024-07-08T211729_adv.csv"
# SOURCEFILE = r"eddypro_CH-CHA_FR-20240706-224026_fluxnet_2024-07-06T224028_adv.csv"
SOURCEDATA = Path(SOURCEDIR) / SOURCEFILE

# Precipitation variables
precipvar = 'P_1_1_1'  # The wrong precipitation in the original files in SOURCE_ORIG

# # Search original files and store filepaths in list
# sourcefiles = search_files(searchdirs=SOURCEDIR, pattern='*')

# Read data from precip files to dataframe
d = ReadFileType(filepath=SOURCEDATA, filetype='EDDYPRO-FLUXNET-CSV-30MIN',
                 output_middle_timestamp=True, data_nrows=50)
df = d.data_df

tlag_cols = [c for c in df.columns if "TLAG" in c]
tlag_min_cols = [c for c in tlag_cols if c.endswith("_MIN")]
tlag_max_cols = [c for c in tlag_cols if c.endswith("_MAX")]
tlag_actual_cols = [c for c in tlag_cols if c.endswith("_ACTUAL")]

print(tlag_actual_cols)

