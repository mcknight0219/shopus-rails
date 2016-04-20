class Subscriber < ActiveRecord::Base
  validates :weixin, presence: true
  before_save :set_default_value

  scope :seller, -> { where(:is_seller => true) }

  def set_default_value
    is_seller ||= false
    true
  end
end
