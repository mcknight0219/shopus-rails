class ProductPublishJob < ActiveJob::Base
  queue_as :default

  def perform(product)
    #Put product onto shelf
  end
end
