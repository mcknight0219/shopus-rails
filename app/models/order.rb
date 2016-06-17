class Order < ActiveRecord::Base
  attr_accessor :order_note, :shipping_method
  attr_writer   :time_used

  belongs_to :good
  belongs_to :subscriber, :through => :good

  scope :fullfilled -> { where(state: :fullfilled) }
  scope :canceled   -> { where(state: :canceled) }

  state_machine :state, :initial => :ordered do

    after_failure :on => all - [:ordered] do |order, transition|
      # A lot to do when order fails
    end

    after_transition any => :canceled, :do => :refund

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

  def initialize(good)
    @time_used = 0
    @order_note = 'Order created'
    self.good = good
    super()
  end

  def time_used
    @time_used.to_i / 1.day
  end

  def refund(transition)
    @order_note = transition.args.first if !transition.args.empty? and transition.args.first.is_a? String
  end

  private
    def ready_to_ship?
      
    end

end
