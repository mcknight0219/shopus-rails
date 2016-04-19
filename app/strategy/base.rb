module Strategy
  module Base

    ACCOUNT = Rails.application.secrets.wechat_account

    def respond_with_text(to, text)
      xml = []
      xml << "<xml>"
      xml << "<ToUserName><![CDATA[#{to}]]></ToUserName>"
      xml << "<FromUserName><![CDATA[#{ACCOUNT}]]></FromUserName>"
      xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
      xml << "<MsgType>![CDATA[text]]</MsgType>"
      xml << "<Content>![CDATA[#{text}]]</Content>"
      xml << "</xml>"

      xml.join "\n"
    end

    def response_with_picture(to, media_id)
      xml = []
      xml << "<xml>"
      xml << "<ToUserName><![CDATA[#{to}]]></ToUserName>"
      xml << "<FromUserName><![CDATA[#{ACCOUNT}]]></FromUserName>"
      xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
      xml << "<MsgType>![CDATA[image]]</MsgType>"
      xml << "<Image><MediaId>![CDATA[#{media_id}]]</MediaId></Image>"
      xml << "</xml>"

      xml.join "\n"
    end

    # NOTE: We only support sending one article at the time
    def respond_with_article(to, **article)
      return 'success' unless articles is_a? Array

      xml = []
      xml << "<xml>"
      xml << "<ToUserName><![CDATA[#{to}]]></ToUserName>"
      xml << "<FromUserName><![CDATA[#{ACCOUNT}]]></FromUserName>"
      xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
      xml << "<MsgType>![CDATA[news]]</MsgType>"
      xml << "<ArticleCount>1</Article>"
      xml << "<Articles><item>"
      xml << "<Title>![CDATA[#{title}]]</Title>"
      xml << "<Description>![CDATA[#{description}]]</Description>"
      xml << "<PicUrl>![CDATA[#{picurl}]]</PicUrl>"
      xml << "<Url>![CDATA[#{url}]]</Url>"
      xml << "</item></Articles>"
      xml << "</xml>"

      xml.join "\n"
    end
  end
end
