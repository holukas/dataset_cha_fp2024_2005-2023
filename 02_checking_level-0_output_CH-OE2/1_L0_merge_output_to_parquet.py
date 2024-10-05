import pandas as pd

from diive.core.io.filereader import search_files, MultiDataFileReader
from diive.core.io.files import save_parquet

# pd.options.display.width = None
# pd.options.display.max_columns = None
pd.set_option('display.max_rows', 3000)
pd.set_option('display.max_columns', 3000)

# Source folders
SOURCEDIR = r"F:\TMP\OE2\IRGA"

# Search original files and store filepaths in list
sourcefiles = search_files(searchdirs=SOURCEDIR, pattern='*')

# Read data from precip files to dataframe
d = MultiDataFileReader(filepaths=sourcefiles,
                        filetype='EDDYPRO-FLUXNET-CSV-30MIN',
                        output_middle_timestamp=True)
df = d.data_df

filepath = save_parquet(filename="merged_all_years", data=df, outpath=SOURCEDIR)
print(filepath)
