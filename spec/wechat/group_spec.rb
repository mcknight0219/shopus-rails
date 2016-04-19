require 'rails_helper'
require 'json'

RSpec.describe Wechat::Group do
  let(:dummy) {Class.new {include Wechat::Group}}
  # In this test for group, we will utilize cache so the access_token will
  # only be requeted once.
  before(:all) do
    stub_request(:get, Wechat::Api::BASE_URI + "/token?appid=wxfd9d6d2aba92b679&grant_type=client_credential&secret=a5a98315d29a068f2d437353a44f5594").
      to_return(:body => {:access_token => "token", :expires_in => 7200}.to_json,
      :status => 200, :headers => {'Content-Type' => 'application/json'})
  end

  after(:all) do
    Rails.cache.delete 'wechat_access_token'
  end

  it "create a group called 'test'" do
    stub_request(:post, Wechat::Api::BASE_URI + "/groups/create?access_token=token").
      to_return(:body => {:group => {:id => 1, :name => 'test'}}.to_json,
      :status => 200, :headers => {'Content-Type' => 'application/json'})

    body = dummy.new.create 'test'
    expect(body[:group][:id]).to eq 1
    expect(body[:group][:name]).to eq 'test'
  end

  it "get all groups definition" do
    stub_request(:get, Wechat::Api::BASE_URI + "/groups/get?access_token=token").
      to_return(:body => {:groups => [{:id => 0, :name => '未分组', :count => 12}, {:id => 1, :name => '黑名单', :count => 0}]}.to_json,
      :status => 200, :headers => {'Content-Type' => 'application/json'})

      body = dummy.new.get
      expect(body[:groups].count).to eq 2
      expect(body[:groups].first[:name]).to eq '未分组'
      expect(body[:groups].last[:count]).to eq 0
  end
end
