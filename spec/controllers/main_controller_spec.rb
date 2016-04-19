require 'rails_helper'

RSpec.describe MainController, type: :controller do

  # Reopen Message class and add #to_xml instance methods
  # so we could conveniently mock the post xml message
  class Message
    def to_xml
      xml = []
      xml << "<xml>"
      xml << "<ToUserName><![CDATA[#{to}]]></ToUserName>"
      xml << "<FromUserName><![CDATA[#{from}]]></FromUserName>"
      xml << "<CreateTime>#{Time.now.to_i}</CreateTime>"
      xml << "<MsgType>![CDATA[#{type}]]</MsgType>"
      xml << "<Event>![CDATA[#{event}]]</Event>" if event?
      xml << "</xml>"
      xml.join("\n")
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "returns echostr if verified" do
      get :index, :echostr    => 'hello',
                  :signature  => '92eb849e5b8853d620e9256573b23379bdd086cc',
                  :timestamp  => '1460580908',
                  :nonce      => '81839956'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq "text/plain"
      expect(response.body).to eq "hello"
    end

    it "returns empty if verification failed" do
      get :index, :echostr => 'hello',
                  :signature  => 'bad signature',
                  :timestamp  => '1460580908',
                  :nonce      => '81839956'

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq "text/plain"
      expect(response.body).to be_empty
    end
  end

  describe "POST #index" do
    it "receive subscribe message and subscribe user" do
      post :index, build(:subscribe_event).to_xml
      expect(response).to have_http_status(:success)
    end

    it "receive unsubscribe message and unsubscribe user" do
      post :index, build(:unsubscribe_event).to_xml
    end
  end
end
