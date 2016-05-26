require 'rails_helper'
require 'base64'

RSpec.describe Logo, type: :model do
  let(:logo)  { create(:logo) }
  let(:image) { fixitre_file }

  before(:all) do
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!
  end

  describe '#fetch' do
    it 'Default data is empty' do
      expect(logo.data).to be_empty
      expect(logo.remote?).to be_truthy
    end

    it 'Download image and store the data' do
      expect {logo.fetch}.to change {logo.data}
    end

    it 'Download the same image as fixture' do
      logo.fetch
      expect(Base64.decode64 logo.data.split(',')[1]).to eq File.read Rails.root.join('spec', 'fixtures', 'logo.svg')
    end

    it 'Skip if file is too large' do
      logo.url = 'http://static.coach.com/aapz_prd/on/demandware.static/Sites-Coach_US-Site/-/default/dw54ab8442/images/coach-logo.png'
      expect {logo.fetch}.to_not change {logo.data}
      expect(logo.remote?).to be_truthy
    end
  end
end