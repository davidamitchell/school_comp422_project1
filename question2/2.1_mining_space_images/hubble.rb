THRESHOLD = 127

require 'chunky_png'

def mean( array )
  array.reduce( :+ ).to_f / array.size.to_f
end

img    = ChunkyPNG::Image.from_file('images/hubble.png')
result = ChunkyPNG::Image.new(img.width, img.height, ChunkyPNG::Color::TRANSPARENT)

for x in 4..img.width-5
  for y in 4..img.height-5

    # a 7x7 mask
    values = []
    ( -3..3 ).each_with_index do |wx, wxi|
      ( -3..3 ).each_with_index do |wy, wyi|
        values <<  ChunkyPNG::Color.to_grayscale_bytes( img[ x+wx, y+wy ] ).first
      end
    end

    # find the mean value
    mean = mean( values ).floor
    mean = mean > THRESHOLD ? 255 : 0
    result[ x, y ] = ChunkyPNG::Color.grayscale( mean )
  end
end

result.save( "images/hubble_min.png" )
