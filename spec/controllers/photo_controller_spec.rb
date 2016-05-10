require 'rails_helper'
RSpec.describe PhotoController, mode: :controller do
  let(:file) { fixture_file_upload("test.png", "image/png") }

  before(:each) do
    session[:openid] = 'test'
  end

  describe '#create' do
    it 'Upload a picture and save it temporarily' do
      post :create, :id => "#{Time.new.to_i}_#{session[:openid]}", 'file' => file 
      expect(response.body).to include_json(
        status: 'ok'
      )
    end
  end

  describe '#destroy' do
    it 'Delete a picture' do
    end
  end
end
