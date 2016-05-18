require 'rails_helper'

RSpec.describe ExpressController, mode: :controller do

  let!(:user)     { create(:a_subscriber) }
  let!(:a_express_method) { create(:a_shipping_method, :subscriber => user) } 
  
  before(:each) do 
    session[:openid] = user.weixin
  end

  describe 'create a new shipping method' do

    it 'Post to create route' do
      expect{
        post :create, {:company => 'shuntong', :country => 'Canada', :unit => 2, :rate => 2.0, :duration => 1, :description => 'comment'}
      }.to change{ExpressMethod.count}.by 1
      expect(response).to redirect_to :controller => :express_select, :action => :new, :mode => 'success'
    end

    it 'Post to create but failed' do
      expect{
        post :create, {:company => 'shuntong', :country => 'Canada', :unit => 5, :rate => 2.0, :duration => 1, :description => 'comment'}
      }.not_to change{ExpressMethod.count}
      expect(response).to redirect_to :controller => :express_select, :action => :new, :mode => 'failure'
    end

    context 'Success' do
      it 'Delete a shipping method' do
        expect {
          delete :destroy, :id => a_express_method.id 
        }.to change {ExpressMethod.count}.by -1
        expect(response.body).to include_json(status: 'ok')
      end
    end
  end

  describe 'Get express methods belong to subscriber' do

    it 'Get all shipping methods' do
      get :index
      expect(response.body).to include_json(status: 'ok', express: [a_express_method.as_json(:except => [:created_at, :updated_at])] )
    end
  end

  describe '#update' do
    it 'Update existing express method rate' do
      patch :update, 
        :id       => a_express_method.id,
        :company  => a_express_method.company, 
        :country  => a_express_method.country,
        :unit     => a_express_method.unit,
        :rate     => 4.01,
        :duration => a_express_method.duration,
        :description => a_express_method.description
      expect(response.body).to include_json(status: 'ok')
      a_express_method.reload
      expect(a_express_method.rate).to eq 4.01
    end

    it 'Update existing express method description' do
      expect { patch :update, :id => a_express_method.id, :description => 'A new description' }.to change {a_express_method.reload.description}
      expect(response.body).to include_json(status: 'ok')
    end

    it 'Update nothing' do
      expect { patch :update, :id => a_express_method.id }.to_not change {a_express_method.reload}
      expect(response.body).to include_json(status: 'ok')

      expect { patch :update, :id => a_express_method.id, :rate => a_express_method.rate }.to_not change {a_express_method.reload}
    end
  end

end
