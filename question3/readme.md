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


# COMP 422 - Project 1 - Question 2

#### 2.1 Mining Space Image

**Note**: the below scripts are expecting to run from within the `2.1_mining_space_images` directory.


To run:
```
 ruby hubble.rb
```

This script assumes that the image to processed is `./images/hubble.png` and outputs its result to `./images/hubble_min.png`.  This outputs a png where the galaxies are identified with a greyscale value of 255.  Using the `convert.sh` script one can convert this PNG file to a PBM file which will be a matrix of 1's and 0's with the 1's denoting where a galaxy is.

```
 ./convert.sh
```

To adjust the threshold there is a `THRESHOLD` constant in the script.
