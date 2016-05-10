require 'rails_helper'

RSpec.describe ProductPhoto, type: :model do
  describe '#initialize' do
    let(:a_photo) { ProductPhoto.create! :format => 'image/png', :temp_path => 'temp/path/to/image' }
    
    it 'Default to not remote and temp_url must exist and product is not assinged' do
      expect(a_photo.stored_remote).to be_falsy
      expect(a_photo.format).to eq 'image/png'
    end

    it 'Once media_id is set, correct fields are set' do
      a_photo.update(:media_id => '1234567')
      expect(a_photo.stored_remote).to be_truthy
      expect(a_photo.temp_path).to be_nil
    end
  end

  describe '#upload' do
    it 'Upload photo to remote storage (qq)' do
    end
  end
end
