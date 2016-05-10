require 'rails_helper'

RSpec.describe ProductPhoto, type: :model do
  let(:a_photo) { ProductPhoto.create! :format => 'image/png', :temp_path => 'temp/path/to/image' }
  describe '#initialize' do
    it 'Default to not remote and temp_url must exist and product is not assinged' do
      expect(a_photo.stored_remote).to be_falsy
      expect(a_photo.format).to eq 'image/png'
    end
  end

  describe '#upload' do
    before(:each) do
      allow(Wechat::Asset).to receive(:add).and_return({media_id: '1234567'})
    end

    it 'Upload photo to remote storage (qq)' do
      expect { a_photo.upload }.to change {a_photo.media_id}
    end

    it 'Destroy remote storage (qq) on deletion' do
      expect(Wechat::Asset).to receive(:delete).with('1234567')
      a_photo.upload
      ProductPhoto.destroy(a_photo.id)
    end
  end

  describe '#download' do
    before(:each) do
      allow(Wechat::Asset).to receive(:add).and_return({media_id: '1234567'})
    end

    it 'Download not-uploaded product photo' do
      expect(a_photo.download).to be_nil
    end

    it 'Download uploaded product photo' do
      pending("need to know more about http stream")
      this_should_not_get_executed
    end
  end
end
