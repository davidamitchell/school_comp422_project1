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

#### 2.2 Face Detection

**Note**: the below scripts are expecting to run from within the `2.2_face_detection` directory.

The face classification process has been broken down into three processes.

* The preprocessing work
* The feature extraction
* The classification

The preprocessing task is only required to run for the if we want to run the feature extraction task.  But as the `data/feature_files.tar.gz` file is provided one could just run the classification task (`./3_classify.sh`)

##### Preprocessing

(**Warning** this task takes a while, and does not _need_ to be run inorder to do the classification)

This step consists of un-taring the training and test tarballs into the `./data` directory.  After which the image files are converted into PNG files as that is what I found to easiest to work with.  This is achieved by running the below bash script from within the :

```
./1_prep.sh path_to_training_tarball path_to_test_tarbal

# for example
./1_prep.sh face.train.tar.gz face.test.tar.gz

# or
./1_prep.sh /vol/courses/comp422/image-databases/mit-cbcl-faces/face.train.tar.gz /vol/courses/comp422/image-databases/mit-cbcl-faces/face.test.tar.gz

```

##### Feature extraction

(**Note** this task does not _need_ to be run and does require that the PNG images prepared in the preprocessing step above are in the correct location (images/training/..., images/test/...))

During this step we process the image files extracting the below features using the ruby script `select_features.rb`:

* mean
* full_sd
* full_entropy
* half_sd
* half_entropy
* moment_tl
* moment_tr
* moment_bl
* moment_br

These features are put into four different `csv` files:

| File                         | Description                |
| ---------------------------- | -------------------------- |
| `data/face.csv`              | The positive training data |
| `data/non-face.csv`          | The negative training data |
| `data/testdata_face.csv`     | The positive test data     |
| `data/testdata_non-face.csv` | The positive test data     |


After which they are put into a tarball `data/feature_files.tar.gz`.

This task is run with the following bash script:
```
  ./2_extract.sh
```

##### Classification

The classification step involves un-taring the above feature set tarball (`data/feature_files.tar.gz`) then running the **Naive Bayes classifier**.  The classifier itself is implemented in the ruby script `classify.rb`.

This classifier uses the above features, making the assumption that they are all of a normal distribution and uses a `pdf` function to compute the likelihood of the test data.  Its output is a list of the features used and the area under the ROC curve.  Additionally it creates an html file (`roc.html`) which contains a graph of the ROC curve.

Upon completion this task removes the un-tared files.

(note: I have included a PNG image (`./roc.png`) as well but this is not produced pragmatically anywhere)


This task is run with the following bash script:
```
  ./3_classify.sh
```
