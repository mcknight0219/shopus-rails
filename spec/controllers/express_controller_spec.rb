require 'rails_helper'

RSpec.describe ExpressController, mode: :controller do

  describe 'create a new shipping method' do
    it 'Post to create route' do
      user = create(:a_subscriber)
      params = {:company => '顺通', :country => 'Canada', :unit => 2, :rate => 2.0, :duration => 1, :description => 'comment'}
      session[:openid] = user.weixin

      expect{post :create, params}.to change{ExpressMethod.count}.by 1
      expect(response).to redirect_to :action => :index, :mode => 'success'
    end

    it 'Post to create but failed' do
      user = create(:a_subscriber)
      params = {:company => '顺通', :country => 'Canada', :unit => 5, :rate => 2.0, :duration => 1, :description => 'comment'}
      session[:openid] = user.weixin

      expect{post :create, params}.not_to change{ExpressMethod.count}
      expect(response).to redirect_to :action => :index, :mode => 'failure'
    end

    context 'Success' do
      let!(:a_subscriber)     { create(:a_subscriber) }
      let!(:a_express_method) { ExpressMethod.create!(company: 'company name', unit: 1, rate: 1.1, country: 'canada', duration: 1, description: 'description', subscriber: a_subscriber) } 

      it 'Delete a shipping method' do
        expect { delete :destroy, :id => a_express_method.id }.to change {ExpressMethod.count}.by -1
        expect(response.body).to include_json(status: 'ok')
      end
    end

    context 'Failure' do
      let!(:a_subscriber)     { create(:a_subscriber) }
      let!(:a_express_method) { ExpressMethod.create!(company: 'company name', unit: 1, rate: 1.1, country: 'canada', duration: 1, description: 'description', subscriber: a_subscriber) } 
      let!(:product)          { Good.create!(name: 'product name', brand: 'brand name', currency: 'CAD', price: 100.0, description: 'na', subscriber: a_subscriber, express_method: a_express_method) }

      it 'Delete a shipping method' do
        expect { delete :destroy, :id => a_express_method.id }.not_to change { ExpressMethod.count }
        expect(response.body).to include_json(status: 'bad')
      end
    end

  end
end
