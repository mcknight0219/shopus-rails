require 'rails_helper'

RSpec.describe GoodsController, type: :controller do
  let(:qs) { "appid=#{Rails.application.secrets.wechat_app_id}&secret=#{Rails.application.secrets.wechat_app_secret}&code=CODE&grant_type=authorization_code" }
  let(:user) { create(:a_subscriber) }

  # Make oauth procedure before each action
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
    let(:params) { {:name => 'Name', :brand => 'Brand', :currency => 'CAD', :price => 100, :description => 'Alineofdescription'} }
    
    describe "Oauth with wechat" do
      it 'Obtains openid and access_token after authorization' do
        get :new, :code => 'CODE'
        expect(response).to render_template(:new)
        expect(assigns(:openid)).to eq(user.weixin)
        expect(assigns(:access_token)).to eq('ACCESS_TOKEN')
      end
    end
  
    describe "No oauth is required when creating another product" do
      it 'G' 
    end

    describe "Submit a form for new product" do
      it 'Create a new product' do
        session[:openid] = user.weixin
        expect{ post :create, params }.to change {Good.count}.by 1
        expect(session[:uploads].present?).to be_falsy
      end

      it 'Render the express#index page upon success' do
        post :create, params
        expect(response).to redirect_to '/express_select/new'
      end
    end
  end

  context 'failure' do
    let(:bad_params) { {:name => 'Name', :brand => 'Brand', :currency => 1, :price => 100, :description => 'Alineofdescription'} }
    describe "Oauth with wechat" do
      it "User denied authorization" do
        get :index
        expect(response).to render_template :unauthorized
      end
    end

    describe "Submit a form for new product" do
      it 'Flash back error' do
        expect(post :create, bad_params).to render_template(:new)
        expect(flash[:error].present?).to be_truthy
      end
    end
  end
end
