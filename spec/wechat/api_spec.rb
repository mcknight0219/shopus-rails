require 'rails_helper'
require 'json'

RSpec.describe Wechat::Api do
  before(:each) do
    Rails.cache.delete 'wechat_access_token'
    stub_request(:get, Wechat::Api::BASE_URI + "/token?appid=wxfd9d6d2aba92b679&grant_type=client_credential&secret=a5a98315d29a068f2d437353a44f5594").
      to_return(:body => {:access_token => "token", :expires_in => 7200}.to_json,
      :status => 200, :headers => {'Content-Type' => 'application/json'})
  end

  let(:extended_class) {Class.new { include Wechat::Api }}

  it 'issue a request to get access token' do
    expect(extended_class.new.token).to eq 'token'
    # check if cached
    expect(Rails.cache.read 'wechat_access_token').to eq 'token'
  end

  it 'issue request to an api endpoint with access token' do
    stub_request(:get, Wechat::Api::BASE_URI + '/endpoint?access_token=token').
      to_return(:body => {:status => "ok"}.to_json, :status => 200, :headers => {'Content-Type' => 'application/json'})

    body = extended_class.new.perform_request('get', 'endpoint')
    expect(body.is_a? Hash).to be_truthy
  end

  it 'issue request to an api endpoint and returns error' do
    stub_request(:get, Wechat::Api::BASE_URI + '/endpoint?access_token=token').
      to_return(:body => {:errcode => 40001, :errmsg => "some error message"}.to_json, :status => 200, :headers => {'Content-Type' => 'application/json'})

    expect{ extended_class.new.perform_request('get', 'endpoint') }.to raise_error(Wechat::Error, 'some error message')
  end
end
