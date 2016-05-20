require 'base64'
require 'open-uri'

class Logo < ActiveRecord::Base
  validates :url, presence: true

  before_save :set_default_values

  # Only download image whose size is less than 32k
  def fetch
    data = open(self.url).read
    mime = 

    update_column :data, "data:image/#{mime_type self.url};base64,#{Base64.encode64(data)}" if data.length < 32 * 1024
  end

  # True if no data is stored in db
  def remote?
    self.data.empty?
  end

  private
    def set_default_values
      self.data ||= ''
    end

    def mime_type url
      format = /[^\.]+\.([a-z]+)$/.match(url)[1]
      if format == 'svg' then "#{format}+xml" else format end
    end
end
