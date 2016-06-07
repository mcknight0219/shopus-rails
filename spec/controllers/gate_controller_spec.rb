require 'rails_helper'

RSpec.describe GateController, type: :controller do
  let(:qs) { "appid=#{Rails.application.secrets.wechat_app_id}&secret=#{Rails.application.secrets.wechat_app_secret}&code=CODE&grant_type=authorization_code" }
  let(:user) { create :a_subscriber }

  before(:each) do
    stub_request(:get, "https://api.weixin.qq.com/sns/oauth2/access_token?#{qs}").
      to_return(
        :body => {:access_token => 'ACCESS_TOKEN',
                          :expires_in => 7200,
                          :refresh_token => "REFRESH_TOKEN",
                          :openid => user.weixin,
                          :scope => "snsapi_base"
        }.to_json,
        :status => 200,
        :headers => {'Content-Type' => 'application/json'})
  end

  context 'success' do
    describe '#index' do
      it 'authenticate and redirect' do
        get :index, :code => 'CODE', :redirectTo => '/goods/new'
        expect(response).to redirect_to '/goods/new'
        expect(assigns(:openid)).to eq user.weixin
        expect(assigns(:access_token)).to eq 'ACCESS_TOKEN'
      end

      it 'authenticate and redirect on '
    end
  end

  context 'failure' do
    it 'authenticate and fail' do
      get :index, :redirectTo => 'goods/new'
      expect(response).to render_template :unauthorized
    end
  end
end
