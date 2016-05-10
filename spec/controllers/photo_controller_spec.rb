require 'rails_helper'
RSpec.describe PhotoController, mode: :controller do
  let(:file) { fixture_file_upload("test.png", "image/png") }

  before(:all) do
    ProductPhoto.delete_all
  end

  after(:all) do
    ProductPhoto.delete_all
  end
  
  describe '#create' do
    it 'Upload a picture and create a photo instance' do
      expect { post :create, 'file' => file }.to change {ProductPhoto.count}.by 1
      expect(response.body).to include_json(
        status: 'ok',
        id: ProductPhoto.last.id
      )
    end

    it 'Upload a picture and remeber in session' do
      post :create, 'file' => file
      expect(session[:uploads].present?).to be_truthy
      expect(session[:uploads].last).to eq ProductPhoto.first.id
    end
  end

  describe '#destroy' do
    it 'Upload a photo and delete it' do
      post :create, 'file' => file
      expect { delete :destroy, id: (JSON.parse response.body)['id'] }.to change {ProductPhoto.count}.by -1
      expect(session[:uploads].present?).to be_falsy
    end

    it 'Upload two photos and delete one' do
      post :create, 'file' => file
      id = JSON.parse(response.body)['id']
      post :create, 'file' => file
      expect(session[:uploads].count).to eq 2

      delete :destroy, id: id
      expect(session[:uploads].count).to eq 1
    end
  end
end
