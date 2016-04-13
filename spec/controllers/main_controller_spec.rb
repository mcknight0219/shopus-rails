require 'rails_helper'

RSpec.describe MainController, type: :controller do

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

end
