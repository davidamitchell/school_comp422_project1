# features to select
# - pixel mean
# - pixel standard deviation
# - pixel entropy
# - (left side SD - right side SD)^2

# returns a ChunkyPNG image which is the
# left half of the image. if the width is even
# the image will be divided evenly. if the width
# is odd the center column is ignored.
#
#   image:: A ChunkyPNG image
#
def left_side( image )
  half = image.width / 2
  image.crop(0, 0, half, image.height)
end

# returns a ChunkyPNG image which is the
# right half of the image. if the width is even
# the image will be divided evenly. if the width
# is odd the center column is ignored.
#
#   image:: A ChunkyPNG image
#
def right_side( image )
  half = ( image.width / 2.0 ).ceil
  image.crop(half, 0, half-1, image.height)
end

# returns a ChunkyPNG image which is the
# top half of the image. if the width is even
# the image will be divided evenly. if the width
# is odd the center row is ignored.
#
#   image:: A ChunkyPNG image
#
def top_side( image )
  half = image.height / 2
  image.crop( 0, 0, image.width, half)
end

# returns a ChunkyPNG image which is the
# bottom half of the image. if the width is even
# the image will be divided evenly. if the width
# is odd the center row is ignored.
#
#   image:: A ChunkyPNG image
#
def bottom_side( image )
  half = ( image.height / 2.0 ).ceil
  image.crop( 0, half, image.width, half-1)
end

def top_left( image )
  left = left_side( image )
  top_side( left )
end

def top_right( image )
  right = right_side( image )
  top_side( right )
end

def bottom_left( image )
  left = left_side( image )
  bottom_side( left )
end

def bottom_right( image )
  right = right_side( image )
  bottom_side( right )
end

# returns the standard deviation of the gray scale
# values of a png image
#
#   image:: A ChunkyPNG image
#
def sd_image( image )
  gray_scale( image.pixels ).standard_deviation
end

# returns the entropy of the gray scale
# values of a png image
#
#   image:: A ChunkyPNG image
#
def entropy_image( image )
  entropy( gray_scale( image.pixels ) )
end

# returns the entropy of the values in an array
#
#   arr:: a numeric single dim array
#
def entropy( arr )
  counts = Hash.new( 0.0 )

  arr.each do |val|
    counts[ val ] += 1
  end

  counts.values.reduce( 0 ) do |entropy, num|
    p = num / arr.size.to_f
    entropy - p * Math.log2( p )
  end
end

# returns the squared difference in standard deviation
# between two images
#
#    image_1:: A ChunkyPGN image
#    image_2:: A ChunkyPGN image
#
def sd_squared_difference( image_1, image_2 )
  ( sd_image( image_1 ) - sd_image( image_2 ) ) ** 2
end


# returns the squared difference in entropy
# between two images
#
#    image_1:: A ChunkyPGN image
#    image_2:: A ChunkyPGN image
#
def entropy_squared_difference( image_1, image_2 )
  ( entropy_image( image_1 ) - entropy_image( image_2 ) ) ** 2
end

# moments
def moments( image )
  tl = top_left( image ).rotate_180
  tr = top_right( image ).rotate_right
  bl = bottom_left( image ).rotate_left
  br = bottom_right( image )

  m_tl = moment( tl )
  m_tr = moment( tr )
  m_bl = moment( bl )
  m_br = moment( br )

  [m_tl, m_tr, m_bl, m_br]
end

def moment( image )
  m = 0.0
  for x in 0..image.width-1
    for y in 0..image.height-1
      val = ChunkyPNG::Color.to_grayscale_bytes( image[ x, y ] ).first.to_f
      dist =  Math.sqrt( ( x ** 2 ) + ( y ** 2 ) )

      m += val * dist
    end
  end

  m / image.pixels.size.to_f
end



def gray_scale(pixels)
  pixels.map do |pixel|
    ChunkyPNG::Color.to_grayscale_bytes( pixel ).first
  end
end

# returns a feature vector including:
#
#   * image name
#   * the mean of the gray scale pixel values
#   * the standard deviation of the gray scale pixel values
#   * the entropy of the gray scale pixel values
#   * the squared difference in standard deviation between the right and
#     left side of the image
#   * the squared difference in entropy between the right and left sides
#     of the image
#
#   image:: A ChunkyPNG image
#
def extract_features( image, is_face )
  name = image.metadata[ :name ]

  mean    = gray_scale( image.pixels ).mean
  sd      = sd_image( image )
  entropy = entropy_image( image )

  left_half  = left_side( image )
  right_half = right_side( image )

  half_sd      = sd_squared_difference( left_half, right_half )
  half_entropy = entropy_squared_difference( left_half, right_half )


  moment_tl, moment_tr, moment_bl, moment_br = moments( image )

  [ name, mean, sd, entropy, half_sd, half_entropy, moment_tl, moment_tr, moment_bl, moment_br, is_face ]
end

def extract( dir, outfile, headers )
  features = []
  features << headers

  puts "extracting features from #{dir}"
  total = Dir[ dir ].size
  count = 1
  Dir[ dir ].each do |face|
    image = ChunkyPNG::Image.from_file(face)
    image.metadata = { name: face.split('/').last.gsub(/\..+/,'') }

    features << extract_features( image, true )
    print "." if count % (total/20) == 0
    count += 1
  end
  puts ''
  puts "writing datafile ./#{outfile}"

  puts ''
  # write it out to a file
  CSV.open(outfile, "wb") do |csv|
    features.each do | feature |
      csv << feature
    end
  end

end


require 'chunky_png'
require 'descriptive_statistics'
require "csv"

FEATURE_HEADER = ["image", "mean", "full_sd", "full_entropy", "half_sd", "half_entropy", "moment_tl", "moment_tr", "moment_bl", "moment_br", "class"]
features = FEATURE_HEADER - ['image', 'class']


B="\033[0;34m\033[1m"
NC="\033[0m"
def h_puts( text )
  puts "#{B}#{text}#{NC}"
end

puts ''
h_puts "Begining Feature Extraction"
puts "Features: #{features}"

puts ''
h_puts "*** Processing Training Data ***"

#####################################################################
# face feature selection
#####################################################################
extract( 'images/train/face/*.png', 'data/face.csv', FEATURE_HEADER )

#####################################################################
# non face feature selection
#####################################################################
extract( 'images/train/non-face/*.png', 'data/non-face.csv', FEATURE_HEADER )

puts ''
h_puts "*** Processing Test Data ***"

#####################################################################
# TESTDATA face feature selection
#####################################################################
extract( 'images/test/face/*.png', 'data/testdata_face.csv', FEATURE_HEADER )

#####################################################################
# TESTDATA non face feature selection
#####################################################################
extract( 'images/test/non-face/*.png', 'data/testdata_non-face.csv', FEATURE_HEADER )
