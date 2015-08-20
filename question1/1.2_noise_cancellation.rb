def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def mean(array)
  (array.reduce(:+).to_f / array.size.to_f)
end

require 'chunky_png'

in_img = ChunkyPNG::Image.from_file('images/1.2_noise_cancellation/ckt-board-saltpep.png')

out_img_mean   = ChunkyPNG::Image.new(in_img.width, in_img.height, ChunkyPNG::Color::TRANSPARENT)
out_img_median = ChunkyPNG::Image.new(in_img.width, in_img.height, ChunkyPNG::Color::TRANSPARENT)

for x in 1..in_img.width-2
  for y in 1..in_img.height-2
    values = []
    (-1..1).each_with_index do |wx, wxi|
      (-1..1).each_with_index do |wy, wyi|
        values <<  ChunkyPNG::Color.to_grayscale_bytes(in_img[x+wx, y+wy]).first
      end
    end

    mean                = mean( values ).floor
    out_img_mean[x,y]   = ChunkyPNG::Color.grayscale(mean)

    median              = median(values).floor
    out_img_median[x,y] = ChunkyPNG::Color.grayscale(median)

  end
end
puts "Writing output image to: images/1.2_noise_cancellation/ckt-board-saltpep_mean.png"
out_img_mean.save('images/1.2_noise_cancellation/ckt-board-saltpep_mean.png')

puts "Writing output image to: images/1.2_noise_cancellation/ckt-board-saltpep_median.png"
out_img_median.save('images/1.2_noise_cancellation/ckt-board-saltpep_median.png')
