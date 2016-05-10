class UploadsProcessJob < ActiveJob::Base
  queue_as :default

  def perform(uploads)
      
  end
end
