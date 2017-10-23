import numpy as np
import pandas as pd
from sklearn import neural_network
from sklearn.preprocessing import StandardScaler, Imputer
from sklearn.metrics import r2_score, make_scorer
from sklearn.model_selection import train_test_split, validation_curve
import matplotlib.pyplot as plt


def create_mapping(train_col):
    keys = train_col.unique().tolist()
    return dict(zip(keys, range(len(keys))))


def crossValidation(X, y, clf):
    X_train, X_test, y_train, y_test = train_test_split(X, y)
    imp.fit(X_train)
    X_train = imp.transform(X_train)

    scaler.fit(X_train)
    X_train = scaler.transform(X_train)

    X_test = imp.transform(X_test)
    X_test = scaler.transform(X_test)

    clf.fit(X_train, y_train)
    prediction = clf.predict(X_test)
    cv_sc = r2_score(y_test, prediction)
    tr_sc = r2_score(y_train, clf.predict(X_train))
    print("CV score :", 200 * cv_sc)
    print("CV error :", 100 / cv_sc - 100)
    print("Train score :", 200 * tr_sc)
    print("Train error :", 100 / tr_sc - 100, "%")


def realTEST(X, y, clf):

    imp.fit(X)
    X = imp.transform(X)

    scaler.fit(X)
    X = scaler.transform(X)

    ann.fit(X, y)
    predict = ann.predict(scaler.transform(imp.transform(test)))
    predict = predict.round(decimals=2)

    predict = predict.reshape(predict.shape[0], 1)
    predict = np.concatenate([id_vec, predict], axis=1)
    predict = pd.DataFrame(data=predict, columns=['House ID', 'Golden Grains'])
    predict.to_csv("../answer.csv", index=False, header=True, sep=',')


def generateCURVE(X, y, clf, param_name, param_val):

    imp.fit(X)
    X = imp.transform(X)
    scaler.fit(X)
    X = scaler.transform(X)
    validation_curve(ann, X, y, param_name, param_val)
    plt.show()


pass


# importing data
train = pd.read_csv('../csv/train.csv')
test = pd.read_csv('../csv/test.csv')
id_vec = np.array(test.loc[:, test.columns == 'House ID'])
# To get the number of rows having atleast one zero
# (train.isnull() == True).sum()

# mapping for BUILDER column
builder_map = create_mapping(train.BUILDER)
# mapping for location column
location_map = create_mapping(train.LOCATION)

# replacing strings by the corresponding integer, using the same mapping
train = train.replace({'BUILDER': builder_map, 'LOCATION': location_map})
test = test.replace({'BUILDER': builder_map, 'LOCATION': location_map})


train = train.drop(['GARDEN'], axis=1)
test = test.drop(['GARDEN'], axis=1)
train['House ID'] = train['House ID'].apply(lambda x: int(x, 16))
test['House ID'] = test['House ID'].apply(lambda x: int(x, 16))

# Seperating target variables from feature matrix
X = train.drop(['Golden Grains'], axis=1)
y = train['Golden Grains']


# Creating classifier objects
imp = Imputer(missing_values='NaN', strategy='mean', axis=0)
scaler = StandardScaler()
ann = neural_network.MLPRegressor(shuffle=True,
                                  alpha=1,
                                  hidden_layer_sizes=(200, 200, 200, 200),
                                  tol=0,
                                  max_iter=500, verbose=True,
                                  random_state=1000)

# CROSS VALIDATION
# crossValidation(X, y, ann)
realTEST(X, y, ann)
# toVary = "hidden_layer_sizes"
# val_toVary = [(50, 50, 50, 50), (100, 100, 100, 100),
# (50, 50, 50), (100, 100, 100)]
# generateCURVE(X, y, ann, toVary, val_toVary)
