class Subscriber < ActiveRecord::Base
  validates :weixin, presence: true
  before_save :set_default_value

  scope :seller, where(:is_seller: true)
  scope :active, where(:active: true)

  private
    def set_default_value
      self.is_seller = false
      self.active = true
    end
end
