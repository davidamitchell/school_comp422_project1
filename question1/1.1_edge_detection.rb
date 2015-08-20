THRESHOLD = 120

require 'chunky_png'

img = ChunkyPNG::Image.from_file( 'images/1.1_edge_detection/test-pattern.png' )

dx = [[-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1]]

dy = [[-1,-2,-1],
      [ 0, 0, 0],
      [ 1, 2, 1]]


edge = ChunkyPNG::Image.new( img.width, img.height, ChunkyPNG::Color::TRANSPARENT )

for x in 1..img.width-2
  for y in 1..img.height-2
    x_val = 0
    y_val = 0
    ( -1..1 ).each_with_index do |wx, wxi|
      ( -1..1 ).each_with_index do |wy, wyi|
        x_val += dx[ wxi ][ wyi ] * ChunkyPNG::Color.to_grayscale_bytes( img[ x+wx, y+wy ] ).first
        y_val += dy[ wxi ][ wyi ] * ChunkyPNG::Color.to_grayscale_bytes( img[ x+wx, y+wy ] ).first
      end
    end
    val = Math.sqrt( ( x_val ** 2 ) + ( y_val ** 2 ) ).ceil

    grey_val = val > THRESHOLD ? 255 : 0
    edge[ x, y ] = ChunkyPNG::Color.grayscale( grey_val )
  end
end

puts "Writing output image to: images/1.1_edge_detection/test-pattern_edge_#{THRESHOLD}.png"
edge.save( "images/1.1_edge_detection/test-pattern_edge_#{THRESHOLD}.png" )
