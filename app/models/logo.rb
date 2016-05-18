require 'base64'
require 'open-uri'

class Logo < ActiveRecord::Base
  validates :url, presence: true

  before_save :set_default_values

  def fetch
    update_column :data, Base64.encode64(open(self.url).read)
  end

  def remote?
    self.data.empty?
  end

  private
    def set_default_values
      self.data ||= ''
    end
end
