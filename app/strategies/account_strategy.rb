class AccountStrategy < BaseStrategy
  def initialize(message)
    @message = message
  end

  def consume
    return subscribe if @message.event == 'subscribe'
    return cancel    if @message.event == 'unsubscribe'
  end

  private
    def subscribe
      Subscriber.create(weixin: @message.from)
      respond_with_text @message.from, 'Welcome to shopus ! Click :Help in menu to know more.'
    end

    def cancel
      Subscriber.find_by(weixin: @message.from).delete
      'success'
    end
end
