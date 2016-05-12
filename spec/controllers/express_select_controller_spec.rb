require 'rails_helper'

RSpec.describe ExpressSelectController, type: :controller do
  describe '#create' do
  let(:user) { create(:a_subscriber) }
  let(:shipping) { create(:a_shipping_method) }
    context 'success' do
      it 'Select an existing shipping and publish' do
        post :create, {express_method: shipping.id, publish: true}
        expect(response).to render_template(:success)
      end
    end
  end
end
