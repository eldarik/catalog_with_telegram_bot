require 'open-uri'

class DownloadImageFromCloudinary < Service
  def call(args)
    @upload = args[:upload]
    @options_for_image = args[:options_for_image]

    set_url
    generate_file_path
    download

    result.data[:file_path] = file_path
    result.success!

    result
  end

  private
  attr_accessor :upload, :file_path, :options_for_image, :url

  def set_url
    @url = Cloudinary::Utils.cloudinary_url(upload&.public_id, options_for_image)
  end

  def generate_file_path
    @file_path = Rails.root.join('tmp', "#{SecureRandom.uuid}.#{upload&.format}")
  end

  def download
    File.open(file_path, 'wb') do |file_write|
      open(url, 'rb') do |file_read|
        file_write.write(file_read.read)
      end
    end
  end
end
