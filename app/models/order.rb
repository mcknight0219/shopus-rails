require 'pry'

class Order < ActiveRecord::Base
  attr_accessor :order_note
  attr_writer   :time_used

  belongs_to :good
  delegate :subscriber, :currency, :price, :express_method, :to => :good

  alias_attribute :seller, :subscriber
  alias_attribute :shipping_method, :express_method

  scope :fullfilled, -> { where(state: :fullfilled) }
  scope :canceled,   -> { where(state: :canceled) }

  after_initialize :setup_instance_var

  state_machine :initial => :ordered do

    after_failure :on => all - [:ordered] do |order, transition|
      # A lot to do when order fails
    end

    after_transition any => :canceled, :do => :after_canceled

    around_transition do |order, transition, block|
      start = Time.now
      block.call
      order.time_used += Time.now - start
    end

    event :take do
      transition :ordered => :shipping
    end

    event :ship do
      transition :shipping => :shipped, :if => :ready_to_ship? 
    end

    event :confirm do
      transition :shipped => :fullfilled
    end

    event :cancel do
      transition all - [:canceled, :fullfilled, :shipped] => :canceled
    end
  end

  def setup_instance_var
    @time_used = 0
    @order_note = 'Order created'
  end

  def time_used
    @time_used.to_i / 1.day
  end

  def ready_to_ship?
    !shipping_method.nil?
  end

  def after_canceled(transition)
    @order_note = transition.args.first if !transition.args.empty? and transition.args.first.is_a? String
  end
end
