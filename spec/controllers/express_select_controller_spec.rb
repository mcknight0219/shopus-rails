require 'rails_helper'

RSpec.describe ExpressSelectController, type: :controller do
  describe '#create' do
    let(:product) { create(:a_product) }
    let(:shipping_method) { create(:a_shipping_method) }

    before(:each) do
      session[:good_in_creating] = product.id
    end

    context 'success' do
      it 'Select an existing shipping and publish' do
        post :create, {express_method: shipping_method.id, publish: true}
        expect(response).to render_template(:success)
      end

      it 'Complete the product creation with express method set' do
        expect { post :create, {express_method: shipping_method.id, publish: true} }.to change {Good.find(product.id).express_method}
      end

    end
  end
end
