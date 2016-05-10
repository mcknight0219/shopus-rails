class Subscriber < ActiveRecord::Base
  validates :weixin, presence: true
  before_save :set_default_value

  has_many :goods, dependent: :destroy
  has_many :express_methods, dependent: :destroy
  has_many :product_photos, :through => :goods

  scope :seller, -> { where(:is_seller => true) }

  private
  def set_default_value
    is_seller ||= false
    true
  end
end
