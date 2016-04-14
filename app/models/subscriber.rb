class Subscriber < ActiveRecord::Base
  validates :weixin, presence: true
  before_save :set_default_value

  private
    def set_default_value
      self.is_seller = false
    end
end
