# nitrogen fert is simply a column with the amount of nitrogen per hectar which was applied
# it consists of zeros and then the amount applied on the day of the fertilization

df['n_fert_decay'] = df['nitrogen_fert']
df['n_fert_decay'].replace(0, pd.NA, inplace=True) # Replace 0 with NaN

# Function to fill NaNs with an exponential decline from the last known value + previous decay residuals
def fill_exponential_decline(series, decay_factor=0.9985):
    last_value = None
    residual = 0
    for i in range(len(series)):
        if pd.isna(series.iloc[i]):
            if last_value is not None:
                residual *= decay_factor
                series.iloc[i] = residual
            else:
                series.iloc[i] = pd.NA
        else:
            if last_value is not None:
                residual = last_value * decay_factor + residual * decay_factor
            else:
                residual = series.iloc[i]
            last_value = series.iloc[i]
            series.iloc[i] += residual - series.iloc[i]
    return series

# Apply the function to fill NaNs
df['n_fert_decay'] = fill_exponential_decline(df['n_fert_decay'])