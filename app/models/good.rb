require 'money'

class Good < ActiveRecord::Base
  CURRENCY_TYPES =  %w(CAD USD CNY).freeze

  validates :currency, inclusion: { in: CURRENCY_TYPES }

  belongs_to :subscriber

  def money
    Money.new(price * 100, currency)
  end
end
