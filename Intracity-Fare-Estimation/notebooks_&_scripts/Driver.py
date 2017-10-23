import numpy as np
import pandas as pd
from sklearn import neural_network
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import r2_score
from sklearn.model_selection import train_test_split
# from sklearn.model_selection import GridSearchCV


def testRUN_crCsv(X, y, ann):
    scaler.fit(X)
    X = scaler.transform(X)
    ann.fit(X, y)
    # Hyperparameter tuning
    # gs.fit(X, y)
    # print("best estimator :\n")
    # print(gs.best_estimator_)
    # print("Best parameters :\n")
    # print(gs.best_params_)
    # print("CV RESULTS : \n")
    # print(gs.cv_results_)
    predict = ann.predict(scaler.transform(test))
    predict = predict.round(decimals=2)
    predict = predict.reshape(predict.shape[0], 1)
    predict = np.concatenate([id_vec, predict], axis=1)
    predict = pd.DataFrame(data=predict, columns=['ID', 'FARE'])
    predict.to_csv("../answer.csv", index=False, header=True, sep=',')


pass


def crossValidate(X, y, ann):
    X_train, X_test, y_train, y_test = train_test_split(X, y)
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)
    ann.fit(X_train, y_train)
    prediction = ann.predict(X_test)
    print("CV performance")
    print(200 * r2_score(y_test, prediction))
    print("Train performance")
    print(200 * r2_score(y_train, ann.predict(X_train)))


# Seperating target variables from feature matrix
train = pd.read_csv('../data/processed_train.csv')
test = pd.read_csv('../data/processed_test.csv')
id_vec = np.array(test.loc[:, test.columns == 'ID'])
label_drop = ['ID', 'cooling','bus','mean_lat', 'mean_long', 'TIME_AM',
            'YEAR','DAY','TIMESTAMP']
train.drop(label_drop, axis=1, inplace=True)
test.drop(label_drop, axis=1, inplace=True)

X = train.drop(['FARE'], axis=1)
y = train['FARE']


# Creating classifier objects
scaler = StandardScaler()
ann = neural_network.MLPRegressor(shuffle=True,
                                  alpha=2,
                                  hidden_layer_sizes=(150,150,150),
                                  max_iter=10000,
                                  random_state=1000,
                                  verbose=True)

# gs = GridSearchCV(ann, param_grid={
# 'hidden_layer_sizes': [(8), (10),
# (10, 10, 10), (70, 50, 20), (15, 15, 15), (40, 40, 40)],
# 'random_state': [100, 1000, 10000],
# 'alpha': [0.01, 0.1, 1.0]},
# n_jobs=-1,
# scoring=make_scorer(r2_score),
# verbose=10)

# CROSS VALIDATION code
crossValidate(X, y, ann)
#  Real testing
testRUN_crCsv(X, y, ann)
#########################################################
