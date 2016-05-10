class UploadsProcessJob < ActiveJob::Base
  queue_as :default

  def perform(photos)
    photos.each do |photo|
      ProductPhoto.find(photo).upload
    end
  end
end
