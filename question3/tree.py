from sklearn import tree
from sklearn import metrics

from pandas import *

import os
import subprocess

def visualize_tree(dt, feature_names, name):
    dotfile = name + ".dot"
    pngfile = name + ".png"

    with open(dotfile, 'w') as f:
        tree.export_graphviz(dt, out_file=f, feature_names=feature_names)

    command = ["dot", "-Tpng", dotfile, "-o", pngfile]
    subprocess.check_call(command)

# file data
d = read_table('data/trainingdata', sep='\s+')
X = d.drop(['num_class'], axis=1)
Y = d.num_class

columns = X.columns.tolist()
labels = d.num_class.unique().tolist()

clf = tree.DecisionTreeClassifier().fit(X, Y)

t = read_table('data/testdata', sep='\s+')
testdata = t.drop(['num_class'], axis=1)
result = clf.predict(testdata)

print( "full features" )
print( metrics.confusion_matrix( t.num_class, result, labels = labels) )
visualize_tree(clf, columns, 'images/dt')

# identify the important features
import numpy as np
imp = np.array( clf.feature_importances_.tolist() )
features = np.array(d.drop(['num_class'], axis=1).columns.tolist() )
b = np.vstack((imp, features)).T
important_features = b[ (b[:,0] != '0.0' ) ]

print( important_features[:,1] )
print( important_features[:,1].size )


##########################################################################
# only the morph features
##########################################################################

from re import compile
re = compile('mfeat-mor*')

morph_features = [x for x in columns if re.match(x)]
X = d[morph_features]

clf = tree.DecisionTreeClassifier().fit(X, Y)

testdata = t[morph_features]
result = clf.predict(testdata)

print( "" )
print( "morph features only" )
print( metrics.confusion_matrix( t.num_class, result, labels = labels) )
visualize_tree(clf, columns, 'images/dt_morph')

# identify the important features
imp = np.array( clf.feature_importances_.tolist() )
features = np.array( morph_features )
b = np.vstack((imp, features)).T
important_features = b[ (b[:,0] != '0.0' ) ]

print( important_features[:,1] )
print( important_features[:,1].size )
