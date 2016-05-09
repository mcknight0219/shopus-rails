class UploadsProcessJob < ActiveJobs::Base
  queue_as :default

  def perform(uploads)
  
  end
end
