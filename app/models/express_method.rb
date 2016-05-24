class ExpressMethod < ActiveRecord::Base
  validates_numericality_of :unit,    :greater_than => 0, :less_than_or_equal_to => 3, :only_integer => true
  validates_numericality_of :duration,:greater_than => 0, :less_than_or_equal_to => 5, :only_integer => true
  validates_numericality_of :rate,    :greater_than_or_equal_to => 0

  validates   :company, :presence => true
  validates   :country, :presence => true
  belongs_to  :subscriber
  has_many    :goods

  UNITS = %w(kg lb a).freeze
  ESTIMATE = ['less than a week', 'two weeks', 'three weeks', 'a month', 'other'].freeze

  def unit
    UNITS[self[:unit]-1]
  end

  def description
    if self[:description].empty? then "No note available" else self[:description] end
  end

  def duration
    ESTIMATE[self[:duration]-1]
  end

  def rate_as(other_unit)
    return rate if unit == 'a'
    return rate if other_unit == unit
    return rate * 2.20462   if other_unit == 'lb' && unit == 'kg'
    return rate * 0.453592  if other_unit == 'kg' && unit == 'lb'
  end

  def can_delete?
    self.goods.empty?   
  end

end
