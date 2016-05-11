require 'rails_helper'

feature 'Subscriber create a good' do
  let(:qs) { "appid=#{Rails.application.secrets.wechat_app_id}&secret=#{Rails.application.secrets.wechat_app_secret}&code=CODE&grant_type=authorization_code" }
  let(:user) { create(:a_subscriber) }

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

  scenario 'with valid input' do
    visit '/goods/new?code=CODE'    
    fill_and_submit_good_form

    expect(page).to have_content '请选择或新增邮寄方式'
  end

  scenario ''

  def fill_and_submit_good_form 
    fill_in 'name',   with: 'bag'
    fill_in 'brand',  with: 'coach'
    select  'CAD',    from: 'currency'
    fill_in 'price',  with: 100.99
    fill_in 'description', with: 'a fantastic women purse'
    click_button '继续'
  end
end
