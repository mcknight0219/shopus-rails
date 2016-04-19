module Strategy
  class Subscribe
    include Base
    def ingest(msg)
      case msg.event
        when 'subscribe'
          subscribe msg
        else
          cancel msg
      end
    end

    private

      def subscribe(msg)
        Subscriber.find_by(:weixin => msg.from).active = true unless Subscriber.where(:weixin => msg.from, :active => false).blank?
        Subscriber.create(weixin: msg.from)
        respond_with_text msg.from, 'Welcome to shopus ! Click :Help in menu to know more.'
      end

      def cancel(msg)
        Subscriber.find_by(:weixin => msg.from).active = false
      end
    end
 end
