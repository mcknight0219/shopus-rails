require 'money'

class Good < ActiveRecord::Base
  CURRENCIES =  %w(CAD USD CNY).freeze
  validates :currency, inclusion: { in: CURRENCIES }


  belongs_to  :subscriber
  belongs_to  :express_method

  scope :invalid, -> { where(:express_method => nil) }

  def money
    Money.new(price * 100, currency)
  end

  def has_express_method?
    express_method.nil?
  end
end
