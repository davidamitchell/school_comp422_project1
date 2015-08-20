#!/bin/bash
# file_root=/Users/davidm/Dropbox/school/comp422/scratch
# file_root=/vol/courses/comp422/datasets/mfeat-digits

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 feature_file_root"
  exit
fi
file_root=$1

if [ ! -d data ]; then
  mkdir data
fi

if [ ! -d images ]; then
  mkdir images
fi

# the output files
training_output_file=data/trainingdata
testing_output_file=data/testdata

# the files expected to be processed
filenames="mfeat-fac mfeat-fou mfeat-kar mfeat-mor mfeat-pix mfeat-zer"

# process each file
for fn in $filenames
do

  # find the number of columns in the file
  count="$(head -n 1 $file_root/$fn | wc -w)"

  i=0
  header="0"

  # add a header for each column in the file
  while [  $i -lt $count ]; do
      let i+=1
      header="$header   $fn-$i"
  done

  # add line number add the header to the file
  awk -F" " '{print NR "   " $0}' $file_root/$fn | awk -v h="$header" 'BEGIN{print h}1' > ${fn}_num
done

# join the files on the line number
join mfeat-fac_num mfeat-fou_num | join - mfeat-kar_num | join - mfeat-mor_num | join - mfeat-pix_num | join - mfeat-zer_num > temp_join

# add the class and trim the line
cat temp_join | awk -F" " '{$1=""; if(NR!=1) {print $0 "  " int((NR-2)/200)} else {print $0 "   num_class"}}' | sed 's/^ *//' > temp_file

# split the data into training and test data
awk '{if(NR%2==0 || NR==1) {print $0} }' temp_file > $training_output_file
awk '{if(NR%2!=0 || NR==1) {print $0} }' temp_file > $testing_output_file


#clean up
rm mfeat*num
rm temp_file
rm temp_join
