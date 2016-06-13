require 'rails_helper'

RSpec.describe GoodsController, type: :controller do
  let(:user) { create(:a_subscriber) }

  before(:each) do
    session[:openid] = user.weixin
  end

  context 'success' do
    let(:params) { {:name => 'Name', :brand => 'Brand', :currency => 'CAD', :price => 100, :description => 'Alineofdescription'} }
    describe "No oauth is required when creating another product" do
      it 'Load page without oauth' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "Submit a form for new product" do
      it 'Create a new product' do
        expect{ post :create, params }.to change {Good.count}.by 1
        expect(session[:uploads].present?).to be_falsy
      end

      it 'Render the express#index page upon success' do
        post :create, params
        expect(response).to redirect_to '/express_select/new'
      end
    end

    describe "Get subscriber's goods list" do
    end
  end

  context 'failure' do
    let(:bad_params) { {:name => 'Name', :brand => 'Brand', :currency => 1, :price => 100, :description => 'Alineofdescription'} }
    
    describe "Submit a form for new product" do
      it 'Flash back error' do
        expect(post :create, bad_params).to render_template(:new)
        expect(flash[:error].present?).to be_truthy
      end
    end
  end
end
