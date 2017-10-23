import numpy as np
import pandas as pd
from sklearn import neural_network
from sklearn.preprocessing import StandardScaler,Imputer
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# importing data
train = pd.read_csv('train.csv')
train = train.loc[:, train.columns != 'blue']


test = pd.read_csv('test.csv')

test_arr = test.loc[:, test.columns != 'id']
test_arr = test_arr.loc[:, test_arr.columns != 'blue']
id_vec = np.array(test.loc[:, test.columns == 'id'])

# Seperating target variables from feature matrix
X = train.loc[:, train.columns != 'price_range']
y = train.loc[:, train.columns == 'price_range']


# Creating classifier objects
imp = Imputer(missing_values=0, strategy='mean', axis=0)
scaler = StandardScaler()
ann = neural_network.MLPClassifier(shuffle=True,
                                   hidden_layer_sizes=(30,30,30,30),
                                   activation="logistic",
                                   tol=0,
                                   warm_start=True,
                                   max_iter=100000, verbose=True,
                                   random_state=1000)

# testing part of code
#######################################################
X_train, X_test, y_train, y_test = train_test_split(X, y)

imp.fit(X_train)
X_train = imp.transform(X_train)

scaler.fit(X_train)
X_train = scaler.transform(X_train)

X_test = imp.transform(X_test)
X_test = scaler.transform(X_test)
ann.fit(X_train, y_train)
predict = ann.predict(X_test)
print(accuracy_score(y_test, predict) * 100)
#######################################################


#  Real testing
########################################################

imp.fit(X)
X = imp.transform(X)

scaler.fit(X)
X = scaler.transform(X)

test_arr = scaler.transform(test_arr)

ann.fit(X, y)
predict = ann.predict(test_arr)

predict = predict.reshape(predict.shape[0], 1)
predict = np.concatenate([id_vec, predict], axis=1)
predict = pd.DataFrame(data=predict, columns=['id', 'price_range'])
predict.to_csv("answer_neural.csv", index=False, header=True, sep=',')
#########################################################
