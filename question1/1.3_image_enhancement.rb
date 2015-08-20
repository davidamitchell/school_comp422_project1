require 'chunky_png'

img = ChunkyPNG::Image.from_file('images/1.3_image_enhancement/blurry-moon.png')

mask_over = [ [ -1, -1, -1 ],
              [ -1,  9, -1 ],
              [ -1, -1, -1 ] ]

mask      = [ [  0, -1,  0 ],
              [ -1,  5, -1 ],
              [  0, -1,  0 ] ]
#
# mask      = [ [ -1,  0, -1 ],
#               [  0,  5,  0 ],
#               [ -1,  0, -1 ] ]

def limit( val )
  val = 255 if val > 255
  val = 0 if val < 0
  return val
end

result      = ChunkyPNG::Image.new( img.width, img.height, ChunkyPNG::Color::TRANSPARENT )
result_over = ChunkyPNG::Image.new( img.width, img.height, ChunkyPNG::Color::TRANSPARENT )

for x in 1..img.width-2
  for y in 1..img.height-2

    val      = 0
    val_over = 0

    ( -1..1 ).each_with_index do |wx, wxi|
      ( -1..1 ).each_with_index do |wy, wyi|
        val      += mask     [ wxi ][ wyi ] * ChunkyPNG::Color.to_grayscale_bytes( img[ x+wx, y+wy ] ).first
        val_over += mask_over[ wxi ][ wyi ] * ChunkyPNG::Color.to_grayscale_bytes( img[ x+wx, y+wy ] ).first
      end
    end

    result     [ x,y ] = ChunkyPNG::Color.grayscale( limit( val      ) )
    result_over[ x,y ] = ChunkyPNG::Color.grayscale( limit( val_over ) )
  end
end

puts "Writing output image to: images/1.3_image_enhancement/moon_sharp.png"
result.save('images/1.3_image_enhancement/moon_sharp.png')

puts "Writing output image to: images/1.3_image_enhancement/moon_over.png"
result_over.save('images/1.3_image_enhancement/moon_over.png')
