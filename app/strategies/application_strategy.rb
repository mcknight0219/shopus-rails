module ApplicationStrategy

  ACCOUNT = Rails.application.secrets.wechat_account

  def respond_with_text(to, text)
    xml = []
    xml << "<xml>"
    xml << "<ToUserName><![CDATA[#{to}]></ToUserName>"
    xml << "<FromUserName><![CDATA[#{ACCOUNT}]></FromUserName>"
    xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
    xml << "<MsgType>![CDATA[text]</MsgType>"
    xml << "<Content>![CDATA[#{text}]</Content>"

    xml.join "\n"
  end

  def response_with_picture(to, media_id)
    xml = []
    xml << "<xml>"
    xml << "<ToUserName><![CDATA[#{to}]></ToUserName>"
    xml << "<FromUserName><![CDATA[#{ACCOUNT}]></FromUserName>"
    xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
    xml << "<MsgType>![CDATA[image]</MsgType>"
    xml << "<Image><MediaId>![CDATA[#{media_id}]</MediaId></Image>"

    xml.join "\n"
  end

  def respond_with_article(to, articles)
    return 'success' unless articles is_a? Array

    xml = []
    xml << "<xml>"
    xml << "<ToUserName><![CDATA[#{to}]></ToUserName>"
    xml << "<FromUserName><![CDATA[#{ACCOUNT}]></FromUserName>"
    xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
    xml << "<MsgType>![CDATA[news]</MsgType>"
    xml << ""

    xml.join "\n"
  end
end