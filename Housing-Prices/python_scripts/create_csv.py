import preprocess
import pandas as pd
import os
from datetime import datetime

# labels / features of the dataframe
labels = ["BUILDER", "House ID", "DATE_BUILT", "DATE_PRICED", "LOCATION",
          "DST_DOCK", "DST_CAPITAL", "DST_MARKET", "DST_TOWER",
          "DST_RIVER", "DST_KNIGHT_HS", "FRNT_FARM_SZ", "GARDEN",
          "RENOVATION", "TREE", "KING_VISIT", "CURSE", "N_BED",
          "N_BATH", "N_DINING", "N_BLESS"]

# creating an empty dataframe with headers
dataFRAME = pd.DataFrame(columns=labels)
dataFRAME.to_csv("../csv/data.csv", index=False, header=True, sep=',')


# ../data_files contain all the data in seperate txt
# files corresponding to each builder
os.chdir('../data_files')
files = os.listdir()

# preprocess.PREPROCESS shall extract and append the data to data.csv
for f in files:
  preprocess.PREPROCESS(f, labels, "../csv/data.csv")


pass
os.chdir('../csv')

# Importing house id's which are missing as missing
missing = pd.read_csv("missing.csv")

# House Id's whose Golden Grains are known as target
target = pd.read_csv("house_prices.csv")

# full data, training + testing (known + unknown)
data = pd.read_csv("data.csv")

d_format = '%m/%d/%Y %I:%M %p'

data['DATE_BUILT'] = [datetime.strptime(
    x, d_format) for x in data['DATE_BUILT']]

data['DAY_BUILT'] = data['DATE_BUILT'].apply(lambda x: x.day)
data['MONTH_BUILT'] = data['DATE_BUILT'].apply(lambda x: x.month)
data['YEAR_BUILT'] = data['DATE_BUILT'].apply(lambda x: x.year)
data['TIME_BUILT'] = data['DATE_BUILT'].apply(lambda x: x.strftime("%H%M"))
data['DATE_BUILT'] = data['DATE_BUILT'].apply(lambda x: x.timestamp())

data['DATE_PRICED'] = [datetime.strptime(
    x, d_format) for x in data['DATE_PRICED']]

data['DAY_PRICED'] = data['DATE_PRICED'].apply(lambda x: x.day)
data['MONTH_PRICED'] = data['DATE_PRICED'].apply(lambda x: x.month)
data['YEAR_PRICED'] = data['DATE_PRICED'].apply(lambda x: x.year)
data['TIME_PRICED'] = data['DATE_PRICED'].apply(lambda x: x.strftime("%H%M"))
data['DATE_PRICED'] = data['DATE_PRICED'].apply(lambda x: x.timestamp())


# selecting rows whose Golden grains are known, a.k.a present in target data
train = data.loc[data['House ID'].isin(target['House ID'])]
train = pd.merge(train, target, on="House ID", how='inner')

# Selecting rows whose Golden Grains are not known
test = data.loc[data['House ID'].isin(missing['House ID'])]
# sorting the test DF, for submission to work
test = test.sort_values(['House ID'], ascending=True)

# saving the dataframe as csv
train.to_csv('train.csv', index=False, header=True)
test.to_csv('test.csv', index=False, header=True)
