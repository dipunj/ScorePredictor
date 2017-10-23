from datetime import datetime
import pandas as pd
import numpy as np


def classify_city(s_lat, s_lon):
    if abs(s_lat - 13) <= 1:
        if abs(s_lon - 80.5) <= 1:
            return 0  # delhi
        elif abs(s_lon - 77.5) <= 1:
            return 1  # banglore
    elif abs(s_lon - 72.5) <= 1:
        return 2  # chennai
    elif abs(s_lat - 25.5) <= 1:
        return 3  # lucknow
    elif abs(s_lon - 88.5) <= 1:
        return 4  # bombay
    elif abs(s_lat - 28.5) <= 1:
        return 5  # kolkata
    else:
        return None


pass


def isAC(vehicle):
    if vehicle == 1 or vehicle == 2 or vehicle == 4:
        return 1
    else:
        return 0


pass


def isPublic(vehicle):
    if vehicle == 0 or vehicle == 3 or vehicle == 5:
        return 1
    else:
        return 0


pass


def findMean_lat(city):
    if city == 0 or city == 1:
        return 13
    elif city == 2:
        return 19.5
    elif city == 3:
        return 25.5
    elif city == 4:
        return 22.5
    elif city == 5:
        return 28.5


pass


def findMean_long(city):
    if city == 0:
        return 80.5
    elif city == 1:
        return 77.5
    elif city == 2:
        return 72.5
    elif city == 3:
        return 83
    elif city == 4:
        return 88.5
    elif city == 5:
        return 77


pass


def preprocess_city(df, mapping):
    df = df.drop(df[(df.STARTING_LATITUDE.isnull()) &
                    (df.DESTINATION_LATITUDE.isnull())].index)
    df.STARTING_LATITUDE.fillna(df.DESTINATION_LATITUDE, inplace=True)
    df.STARTING_LONGITUDE.fillna(df.DESTINATION_LONGITUDE, inplace=True)
    df.DESTINATION_LATITUDE.fillna(df.STARTING_LATITUDE, inplace=True)
    df.DESTINATION_LONGITUDE.fillna(df.STARTING_LONGITUDE, inplace=True)
    df.fillna(-1, inplace=True)
    d_format = '%Y-%m-%d %H:%M:%S'
    df['TIMESTAMP'] = [datetime.strptime(
        x, d_format) for x in df['TIMESTAMP']]
    df['MONTH'] = df['TIMESTAMP'].apply(lambda x: x.month)
    df['DAY'] = df['TIMESTAMP'].apply(lambda x: x.day)
    df['YEAR'] = df['TIMESTAMP'].apply(lambda x: x.year)
    df['TIME'] = df['TIMESTAMP'].apply(lambda x: x.strftime("%H%M"))
    df['TIME_AM'] = df['TIMESTAMP'].apply(
        lambda x: 0 if x.strftime("%p") == "AM" else 1)
    df['weekday'] = df['TIMESTAMP'].apply(lambda x: x.dayofweek)
    df.TIMESTAMP = df['TIMESTAMP'].apply(lambda x: x.timestamp())
    df.VEHICLE_TYPE = df.VEHICLE_TYPE.str.lower()
    df = df.replace({"VEHICLE_TYPE": mapping})
    df['bus'] = df.apply(lambda x: 1 if (
        x['VEHICLE_TYPE'] == 0 or x['VEHICLE_TYPE'] == 4 or x['VEHICLE_TYPE'] == 5)else 0, axis=1)
    df['taxi'] = df.apply(lambda x: 1 if x['VEHICLE_TYPE'] == 6 else 0, axis=1)

    df['cooling'] = df.apply(lambda x: isAC(x['VEHICLE_TYPE']), axis=1)
    df['public'] = df.apply(lambda x: isPublic(x['VEHICLE_TYPE']), axis=1)
    df['city'] = df.apply(lambda x: classify_city(
        x['STARTING_LATITUDE'], x['STARTING_LONGITUDE']), axis=1)
    df['mean_lat'] = df['city'].apply(lambda x: findMean_lat(x))
    df['mean_long'] = df['city'].apply(lambda x: findMean_long(x))
    # df.STARTING_LONGITUDE = df.apply(
        # lambda x: x['mean_long'] - x['STARTING_LONGITUDE'], axis=1)
    # df.DESTINATION_LONGITUDE = df.apply(
        # lambda x: x['mean_long'] - x['DESTINATION_LONGITUDE'], axis=1)
    # df.STARTING_LATITUDE = df.apply(
        # lambda x: x['mean_lat'] - x['STARTING_LATITUDE'], axis=1)
    # df.DESTINATION_LATITUDE = df.apply(
        # lambda x: x['mean_lat'] - x['DESTINATION_LATITUDE'], axis=1)
    df.reset_index(drop=True)
    return df


pass


# mapping(string --> integer) for VEHICLE_TYPE column
def create_mapping(train_col):
    keys = train_col.str.lower().unique().tolist()
    return dict(zip(keys, range(len(keys))))


pass


# importing data
train = pd.read_csv('../data/intracity_fare_train.csv')
test = pd.read_csv('../data/intracity_fare_test.csv')
id_vec = np.array(test.loc[:, test.columns == 'ID'])

# To get the number of rows having atleast one zero
# (train.isnull() == True).sum()

vehicle_map = create_mapping(train.VEHICLE_TYPE)
train = preprocess_city(train, vehicle_map)
test = preprocess_city(test, vehicle_map)

train.to_csv("../data/processed_train.csv", index=False)
test.to_csv("../data/processed_test.csv", index=False)
