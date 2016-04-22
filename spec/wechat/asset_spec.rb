require "rails_helper"
require 'json'

RSpec.describe Wechat::Asset do
  # In this test, we will utilize cache so the access_token will
  # only be requeted once.
  before(:all) do
    stub_request(:get, Wechat::Api::BASE_URI + "/token?appid=wxfd9d6d2aba92b679&grant_type=client_credential&secret=a5a98315d29a068f2d437353a44f5594").
      to_return(:body => {:access_token => "token", :expires_in => 7200}.to_json,
      :status => 200, :headers => {'Content-Type' => 'application/json'})
  end

  after(:all) do
    Rails.cache.delete 'wechat_access_token'
  end

  it 'count the number of news assets' do
    stub_request(:get, Wechat::Api::BASE_URI + '/material/get_materialcount?access_token=token').
      to_return(:body => {:news_count => 1}.to_json,
      :status => 200, :headers => {'Content-Type' => 'application/json'})

    expect(Wechat::Asset.count(:news)[:news_count]).to eq 1
  end

end