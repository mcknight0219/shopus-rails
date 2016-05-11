require 'rails_helper'

RSpec.describe ExpressSelectController, type: :controller do
  let(:user) { create(:a_subscriber) }

  describe '#create' do
    context 'success' do
      it 'Select an existing shipping ' do
        expect {post :create, {} }
      end
    end
  end
end
