class SubscriberStrategy
  include ApplicationStrategy

  def ingest(msg)

    respond_with_text msg.from, 'Welcome to shopus ! Click :Help in menu to know more.'
  end
end