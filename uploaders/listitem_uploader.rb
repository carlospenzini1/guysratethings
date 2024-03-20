require 'carrierwave'
class ListitemUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
end
