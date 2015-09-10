# COMP 422 - Project 1 - Question 3

#### 3.1 Object Recognition

In order to process the feature files into something which a decision tree classifier can use easily I have writen a bash script which uses a combination of bash commands (`awk`, `join`) to produce two files:

* `data/trainingdata`  -- the training data
* `data/testdata`      -- the test data

To run this script:
```
 ./parse_feature_files.sh the_path_to_the_mfeat_files

 # for example
 ./parse_feature_files.sh /vol/courses/comp422/datasets/mfeat-digits
```

Then to construct both trees (one with all features and one with only the morph features)
```
  python tree.py
```

This will produce some files in the `images` directory.  One `dt.png` the decision tree constructed when all features where used and one `dt_morph.png` which is the decision tree constructed when only the morphological where used.

Also it will output both confusion matrices and a list of which features where used during the tree's construction.
