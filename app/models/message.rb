
class Message
  include ActiveModel::Model
  attr_accessor :from, :to, :create_time, :type, :extra

  def initialize(xml_doc)
    self.build_from!(xml_doc.xml)
  end

  def event?
    @type == 'event'
  end

  def respond
    # Message we don't bother to handle
    return 'success' unless @extra
    if self.event? then self.handle_event else self.handle_normal
  end

  private
    def build_from!(xml)
      # common parts
      @from = xml.FromUserName.content
      @to   = xml.ToUserName.content
      @create_time = xml.CreateTime.content
      @type = xml.MsgType.content

      case @type
      when 'text'
        @extra = {:content => xml.Content.content}
      when 'image'
        @extra = {:pic_url => xml.PicUrl.content, :media_id => xml.MediaId}
      when 'link'
        @extra = {:title => xml.Title.content, :description => xml.Description.content, :url => xml.Url.content}
      when 'event'
        @extra = self.build_event_extra xml
      else
        @extra = nil
      end
    end

    def build_event_extra xml
    end
end