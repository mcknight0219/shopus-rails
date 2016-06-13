module MainHelper

  def extract_hash_from_xml(doc)
    attrs = {}
    # common parts
    attrs[:from] = doc.FromUserName.content
    attrs[:to]   = doc.ToUserName.content
    attrs[:type] = doc.MsgType.content.downcase
    attrs[:create_time] = doc.CreateTime.content
    case attrs[:type]
    when 'text'
      attrs[:content] = doc.Content.content
    when 'image'
      attrs.merge!({ :pic_url => doc.PicUrl.content, :media_id => doc.MediaId.content })
    when 'link'
      attrs.merge!({ :title => doc.Title.content, :description => doc.Description.content, :url => doc.Url.content })
    when 'event'
      attrs.merge!({ :event => doc.Event.content })
      case attrs[:event]
      when 'view', 'click'
        attrs[:event_key] = doc.EventKey.content
      when 'location'
        attrs.merge!({ :latitude => doc.Latitude.content, :longitude => doc.Longitude.content, :precision => doc.Precision.content })
      when 'scan'
        attrs.merge!({ :event_key => doc.EventKey.content, :ticket => doc.Ticket.content })
      when 'subscribe'
        # Scan to subscribe event
        attrs.merge!({ :event_key => doc.EventKey.content, :ticket => doc.Ticket.content} ) if doc.has_attribute?('EventKey')
      end
    end
    attrs
  end

  def current_subscriber
    return nil unless session[:openid]
    Subscriber.find_by(:weixin => session[:openid])
  end

  def assert_wechat_granted
    return render template: :unauthorized if current_subscriber.nil?
  end

  def unpack_profile_data
    return unless session.has_key? :profile
    JSON.parse(session[:profile]).each do |key, value|
      self.instance_variable_set "@#{key}", value
    end
  end
end
