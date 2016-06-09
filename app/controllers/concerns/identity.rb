require 'http'

module Identity
  extend ActiveSupport::Concern

  def auth_with_wechat
    token = HTTP.get("#{Rails.application.secrets.sns_auth_server}oauth2/access_token", :params => {:appid => Rails.application.secrets.wechat_app_id, :secret => Rails.application.secrets.wechat_app_secret, :code => params[:code], :grant_type => 'authorization_code'}).parse
    @openid = token["openid"]
    @access_token = token['access_token']
    session[:openid] = @openid
    if token["scope"] == 'snsapi_userinfo'
      profile =  HTTP.get("#{Rails.application.secrets.sns_auth_server}userinfo", :params => {:access_token => @access_token, :openid => @openid, :lang => 'zh_CN'}).parse
      @nickname   = profile["nickname"]
      @headimage  = profile["headimageurl"]
      @sex        = [:na, :m, :f].at profile["sex"].to_i

      session[:headimage] = @headimage
    end
  end
end
