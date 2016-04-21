require 'rails_helper'
require 'json'

RSpec.describe GoodsController, type: :controller do
  let(:qs) { "appid=#{Rails.application.secrets.wechat_app_id}&secret=#{Rails.application.secrets.wechat_app_secret}&code=CODE&grant_type=authorization_code" }

  # Make oauth procedure before each action
  before(:each) do
    stub_request(:get, "https://api.weixin.qq.com/sns/oauth2/access_token?#{qs}").
      to_return(:body => {:access_token => 'ACCESS_TOKEN', :expires_in => 7200, :refresh_token => "REFRESH_TOKEN", :openid => "OPENID", :scope => "snsapi_base"}.to_json,
        :status => 200, :headers => {'Content-Type' => 'application/json'})
  end

  describe "Oauth with wechat" do
    it 'obtains openid and access_token after authorization' do
      get :index, :code => 'CODE'
      expect(response).to render_template(:index)
      expect(assigns(:openid)).to eq('OPENID')
      expect(assigns(:access_token)).to eq('ACCESS_TOKEN')
    end

    # The callback url doesn't have _code_ parameter
    it "user denies our request" do
      get :index
      expect(response).to  render_template(:file => "#{Rails.root}/public/401.html")
    end
  end
end
