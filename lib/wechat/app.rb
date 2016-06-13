require 'sinatra'
require 'json'


# Simulate OAuth with wechat server and pull
# user info so we can reasonably test pages
# in development env.
get '/api/oauth2/access_token' do
  content_type :json
  unless params.has_key?('code')
    {errcode: 40029, errmsg: 'invalid code'}.to_json
  else
    {
      access_token: 'ACCESS_TOKEN', 
      expires_in: 7200,
      refresh_token: 'REFRESH_TOKEN',
      openid: 'weixin',
      scope: 'snsapi_userinfo'
    }.to_json
  end
end

get '/api/userinfo' do
  content_type :json
  if params['access_token'] != 'ACCESS_TOKEN'
    {errcode: 40003, errmsg: 'invalid openid'}.to_json
  else
    {
      openid: params['openid'],
      nickname: 'mcknight0219',
      sex: 1,
      headimage: "https://upload.wikimedia.org/wikipedia/commons/0/07/Avatar_girl_face.png"
    }.to_json
  end
end
