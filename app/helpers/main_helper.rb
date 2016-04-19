module MainHelper

  def dispatch_message(msg)
    yield Strategy::Subscribe.new.ingest msg if msg.subscribe_event?
  end

  def extract_hash_from_xml(doc)
    attrs = {}
    # common parts
    attrs[:from] = xml.FromUserName.content
    attrs[:to]   = xml.ToUserName.content
    attrs[:type] = xml.MsgType.content.downcase
    attrs[:create_time] = xml.CreateTime.content
    case attrs[:type]
      when 'text'
        attrs[:extra] = {:content => xml.Content.content}
      when 'image'
        attrs[:extra] = {:pic_url => xml.PicUrl.content, :media_id => xml.MediaId.content}
      when 'link'
        attrs[:extra] = {:title => xml.Title.content, :description => xml.Description.content, :url => xml.Url.content}
      when 'event'
        extra = {:event => xml.Event.content}
        case extra[:event]
          when 'view', 'click'
            extra[:event_key] = xml.EventKey.content
          when 'location'
            extra[:latitude => xml.Latitude.content, :longitude => xml.Longitude.content, :precision => xml.Precision.content]
          when 'scan'
            extra[:event_key => xml.EventKey.content, :ticket => xml.Ticket.content]
          when 'subscribe'
            # Scan to subscribe event
            extra[:event_key => xml.EventKey.content, :ticket => xml.Ticket.content] if xml.has_attribute?('EventKey')
          else

        end
        attrs[:extra] = extra
      else
        attrs[:extra] = nil
    end

    attrs
  end
end
