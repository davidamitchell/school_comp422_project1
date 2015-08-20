# COMP 422 - Project 1 - Question 2

#### Mining Space Images

To run:
```
 ruby 2.1_mining_space_images/hubble.rb
```


This script assumes that the image to processed is `./images/hubble.png` and outputs its result to `./images/hubble_min.png`.

The in order to turn this PNG file into a binary map I used `pngtopam`.  Running the below will create a file `./images/hubble_min_b.pbm`.

```
 ./convert.sh
```

To adjust the threshold there is a `THRESHOLD` constant in the script.
