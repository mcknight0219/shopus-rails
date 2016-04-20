# Representing the messages we receive from Weixin.
# There are two kinds: event and user sent
class Message
  def initialize(props)
    props.each { |k,v| instance_variable_set("@#{k}", v) }
    class <<self
      self
    end.class_eval do
      props.each { |k, v| attr_accessor k}
    end
  end

  def event?
    @type == 'event'
  end

  def user_sent?
    not event?
  end

  def account_event?
    event? and @event == 'subscribe' || @event == 'unsubscribe'
  end
end
