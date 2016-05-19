require 'rails_helper'

RSpec.describe LogoController, type: :controller do
  let(:logo) { create(:logo) }
  
  before(:all) do
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!
  end

  describe "GET #show" do
    it "returns empty json if no logo with the name" do
      get :show, :name => 'unknown'
      expect(response.body).to include_json(
        status: 'ok'
      )
    end

    it "returns url if logo is not fetched" do
      get :show, :name => logo.name
      expect(response.body).to include_json(
        status: 'ok',
        url:    logo.url
      )
    end

    it "returns data if logo is fetched" do
      logo.fetch
      get :show, :name => logo.name
      expect(response.body).to include_json(
        status: 'ok',
        data:   logo.data
      )
    end
  end

end
