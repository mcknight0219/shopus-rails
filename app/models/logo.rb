require 'base64'
require 'open-uri'

class Logo < ActiveRecord::Base
  validates :url, presence: true

  before_save :set_default_values

  # Only download image whose size is less than 32k
  def fetch
    data = open(self.url).read
    update_column :data, Base64.encode64(data) if data.length < 32 * 1024
  end

  # True if no data is stored in db
  def remote?
    self.data.empty?
  end

  private
    def set_default_values
      self.data ||= ''
    end
end
