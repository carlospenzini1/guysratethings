require 'carrierwave'
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  def store_dir
    'uploads'
  end
end
