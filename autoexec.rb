#!/usr/bin/env ruby

# Place this file in /root/autoexec.sh

require 'libroute/component'
require 'rmagick'
include Magick

def lcol(s)
  s = s / 255
  if (s <= 0.04045)
    linear = s / 12.92
  else
    linear = ((s + 0.055) / 1.055) ** 2.4
  end
  out = linear * 255
  out
end

Libroute::Component.run do |options|

  result = Hash.new

  im = Image.from_blob(options['input'].data).first
  if im.colorspace == Magick::SRGBColorspace
    bGam = true
  else
    bGam = false
  end

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
      if bGam
        pp = [lcol(p.red),lcol(p.green),lcol(p.blue)]
      else
        pp = [p.red,p.green,p.blue]
      end
      psum[0] += pp[0]
      psum[1] += pp[1]
      psum[2] += pp[2]
    end
    s += "#{col+1} #{psum[0]} #{psum[1]} #{psum[2]}\n"
  end

  result['output'] = BSON::Binary.new(s)
  result
end

