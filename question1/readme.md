# COMP 422 - Project 1 - Question 1

The processing of images in this section is done with Ruby.  It is a bit slower than something like C(++) or Java but the amount of code needed to get something done in this space is substantially less.  Since this exercise is about understanding the basics of image processing I deemed it more important to be up and running fast and with less code than worry about allocating memory or dealing with the amazing amount of boiler plate code needed for Java.

In addition to using Ruby as the main image processing language I have converted all the images in question to PNG images.  The reasons for this are two fold: firstly it makes for viewing the results much easier and secondly the library which I choose to assit (http://chunkypng.com/) in the opening and writing of the images files only works with PNG images.

To view the resulting images over X one can use the `eog` program, for example to view the output of 1.2:
```
  eog images/1.2_noise_cancellation/ckt-board-saltpep_median.png
```
(**note** you must have established your `ssh` connection with the `-Y` flag `ssh -Y mitchedavi3@greta-pt.ecs.vuw.ac.nz` )

#### 1.1 Edge Detection

To run:
```
 ruby 1.1_edge_detection.rb
```

This script assumes that the image to processed is `./images/1.1_edge_detection/test-pattern.png` and outputs its result to `./images/1.1_edge_detection/test-pattern_edge_120.png` if the threshold is set to **120**.

To adjust the threshold there is a `THRESHOLD` constant in the script.

#### 1.2 Noise Cancellation

To run:
```
 ruby 1.2_noise_cancellation.rb
```

This script assumes that the image to be processed is `images/1.2_noise_cancellation/ckt-board-saltpep.png`.  It outputs its results in two files:

* `images/1.2_noise_cancellation/ckt-board-saltpep_mean.png` --  produced using the mean filter
* `images/1.2_noise_cancellation/ckt-board-saltpep_median.png` --  produced using the median filter

#### 1.3 Image Enhancement

To run:
```
 ruby 1.3_image_enhancement.rb
```

This script assumes that the image to be processed is `images/1.3_image_enhancement/blurry-moon.png`.  It outputs its results in two files:

* `images/1.3_image_enhancement/moon_sharp.png` --  produced using the sharpen mask (variable `mask` in the script)
* `images/1.3_image_enhancement/moon_over.png` --  produced using the over sharpen mask (variable `mask_over` in the script)
