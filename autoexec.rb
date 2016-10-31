#!/usr/bin/env ruby

# Place this file in /root/autoexec.sh

require 'libroute/component'
require 'rmagick'
include Magick

Libroute::Component.run do |options|

  result = Hash.new

  im = Image.from_blob(options['input'].data).first
  im = im.quantize(256, Magick::RGBColorspace)
  # Convert to fits image
#  im.format = 'fits'
#  result['output'] = BSON::Binary.new(im.to_blob)

  # Sum pixels
  ncols = 1
  s = ''
  (0..im.columns-1).each do |col|
    px = im.get_pixels(col, 0, ncols, im.rows)
    psum = [0,0,0]
    px.each do |p|
      psum[0] += p.red
      psum[1] += p.green
      psum[2] += p.blue
    end
    s += "#{col+1} #{psum[0]} #{psum[1]} #{psum[2]}\n"
  end

  result['output'] = BSON::Binary.new(s)
  result
end
