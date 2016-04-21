require 'http'

module SnsapiBase
  extend ActiveSupport::Concern

  def snsapi_base_auth
    return render_401 unless params.key?(:code)
    secrets = Rails.application.secrets
    auth = sym_recursive HTTP.get('https://api.weixin.qq.com/sns/oauth2/access_token', :params =>
      {:appid => secrets.wechat_app_id, :secret => secrets.wechat_app_secret, :code => params[:code], :grant_type => 'authorization_code'}).parse

    if auth.key? :openid then @openid = auth[:openid]; @access_token = auth[:access_token] else render_401 end
  end

  def sym_recursive e
    return e.map { |e| sym_recursive e } if e.is_a? Array
    return e.inject({}) { |h, (k, v)| h[k.to_sym] = sym_recursive(v); h } if e.is_a? Hash
    e
  end

  def render_401
    render :file => 'public/401.html', :layout => false, :status => :unauthorized
  end
end
