require 'descriptive_statistics'
require 'rubystats'
require 'csv'

# hold the training data
@mean_cache = Hash.new { |h, k| h[k] = {} }
@sd_cache = Hash.new { |h, k| h[k] = {} }


# Calculate the Area under the curve for an ROC curve
#
#   testdata:: this is an array of hashes each in the format:
#
#                  {
#                     ratio:    0.7891234,
#                     is_face:  false
#                  }
#
#              where +ratio+ is the ratio between positive/negitive
#              and +is_face+ is a boolean which denotes if the test
#              instance refers to a face (positive) or not (negitive)
#
# This will return an array of the [ auc, points ], where points are the
# (x,y) plots for the ROC curve graph.
#
def auc_roc( testdata )
  points     = []   # hold the ROC graph points
  auc        = 0.0  # hold the calculated area under the curve
  fp         = 0.0  # the false pos counts
  tp         = 0.0  # the true pos counts
  prev_fp    = 0.0  # the previous false pos counts
  prev_tp    = 0.0  # the previous true pos counts
  prev_ratio = nil  # the previous ratio

  # sort the testdata, decending
  sorted = testdata.sort{ |a,b| b[:ratio] <=> a[:ratio] }
  p = sorted.count { |i| i[ :is_face ] }.to_f
  n = sorted.count { |i| !i[ :is_face ] }.to_f

  # for each test instance
  sorted.each do |instance|

    if instance[:ratio] != prev_ratio
      # points << [ fp/n, tp/p ]

      auc        += ( fp - prev_fp ).abs * ( tp + prev_tp ) / 2.0
      prev_fp     = fp
      prev_tp     = tp
      prev_ratio  = instance[ :ratio ]
    end

    if instance[ :is_face ]
      points << [ fp/n, tp/p ]
      tp += 1
    else
      fp += 1
    end
  end

  auc += ( ( n - prev_fp ).abs * ( p + prev_tp ) / 2.0 )
  auc  = auc / ( p * n )

  # this will be the 1,1 point
  points << [ fp/n, tp/p ]

  {:auc => auc, :points => points}
end

# returns the mean value for this +header+ field and class
# the data is cached for each header/class pair
#
#   header:: the string representing this val feature
#   is_face:: whether or not we are testing for a face
#   data:: the training data
#
def mean_value_for( header, is_face, data )
  @mean_cache[ header ][ is_face.to_s ] ||= data.mean
end

# returns the standard deviation value for this +header+ field and class
# the data is cached for each header/class pair
#
#   header:: the string representing this val feature
#   is_face:: whether or not we are testing for a face
#   data:: the training data
#
def sd_value_for( header, is_face, data )
  @sd_cache[ header ][ is_face.to_s ] ||= data.standard_deviation
end

# returns the non-normalised "probability" of *val* given
# the dataset in *data*.
#
# it is assumed that the data in *data* fits to a normal
# distribution
#
#   val::  a numeric value
#   header:: the string representing this val feature
#   is_face:: whether or not we are testing for a face
#   data:: the training data
#
def pdf_probability( val, header, is_face, data )
  mean = mean_value_for( header, is_face, data )
  sd = sd_value_for( header, is_face, data )
  g = Rubystats::NormalDistribution.new(mean, sd)
  return g.pdf(val)
end


def print_a( a )
  a.keys.sort.each do |k|
    puts "%3d %5d %s\n" % [k, a[k], "#" * (a[k])]
  end
end


FEATURES = ["mean", "full_sd", "full_entropy", "half_sd", "half_entropy", "moment_tl", "moment_tr", "moment_bl", "moment_br"]

# load the features from the data files
#
face_feature_vectors     = Hash.new { |h, k| h[k] = [] }
non_face_feature_vectors = Hash.new { |h, k| h[k] = [] }

CSV.foreach('./data/face.csv', :headers => true) do |c|
  FEATURES.each do |h|
    face_feature_vectors[h] << c[h].to_f
  end
end

CSV.foreach('./data/non-face.csv', :headers => true) do |c|
  FEATURES.each do |h|
    non_face_feature_vectors[h] << c[h].to_f
  end
end

num_test_faces     = File.open("./data/face.csv","r").readlines.size - 1
num_test_non_faces = File.open("./data/non-face.csv","r").readlines.size - 1
face_prior         = num_test_faces     / ( num_test_faces + num_test_non_faces ).to_f
non_face_prior     = num_test_non_faces / ( num_test_faces + num_test_non_faces ).to_f

face_ratios = []
nonface_ratios = []

CSV.foreach('./data/testdata_face.csv', :headers => true) do |c|
  face_likelyhood     = 1.0
  non_face_likelyhood = 1.0
  face_likelyhood     = face_prior
  non_face_likelyhood = non_face_prior

  FEATURES.each do |h|
    face_likelyhood     *= pdf_probability( c[ h ].to_f, h, true, face_feature_vectors[h] )
    non_face_likelyhood *= pdf_probability( c[ h ].to_f, h, false, non_face_feature_vectors[h] )
  end
  ratio = face_likelyhood / non_face_likelyhood

  face_ratios << { ratio: ratio, is_face: true }
end


CSV.foreach('./data/testdata_non-face.csv', :headers => true) do |c|
  face_likelyhood     = 1.0
  non_face_likelyhood = 1.0
  face_likelyhood     = face_prior
  non_face_likelyhood = non_face_prior

  FEATURES.each do |h|
    face_likelyhood     *= pdf_probability( c[ h ].to_f, h, true, face_feature_vectors[h] )
    non_face_likelyhood *= pdf_probability( c[ h ].to_f, h, false, non_face_feature_vectors[h] )
  end
  ratio = face_likelyhood / non_face_likelyhood

  nonface_ratios << { ratio: ratio, is_face: false }
end


testdata = face_ratios + nonface_ratios
auc = auc_roc( testdata )

puts '******************************************'
puts "FEATURES: #{FEATURES}"
puts "AUC of the ROC: #{auc[:auc]}"
puts '******************************************'

points = auc[:points]
# puts "points: #{points.first(3)} ... #{points.last(3)}"


# graph the ROC
require 'nyaplot'
plot = Nyaplot::Plot.new
plot.x_label("FPR")
plot.y_label("TPR")

plot.add(:line, points.map{ |p| p[0] }, points.map{ |p| p[1] })

plot.legend(true)
plot.legend_options({line: "something"})

plot.xrange([0.0, 1.0])
plot.yrange([0.0, 1.0])
plot.bg_color('white')
plot.diagrams.first.title "ROC curve: AUC #{ ( auc[:auc] * 10000 ).to_i / 10000.0 }"
plot.export_html 'roc.html'
