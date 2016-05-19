require 'rails_helper'

RSpec.describe ExpressMethod, type: :model do
  let (:user) { create :a_subscriber }
  let! (:express_method) { ExpressMethod.create!(company: 'company name', unit: 1, rate: 1.0, country: 'canada', duration: 1, description: 'description', subscriber: user) }
  let! (:product) { Good.create!(name: 'product name', brand: 'brand name', currency: 'CAD', price: 100.0, description: 'na', subscriber: user, express_method: express_method) }

  describe "#initialize" do
    it 'Access attributes' do
      expect(express_method.unit).to eq 'kg'
      expect(express_method.shipping_estimate).to eq 'less than a week'
    end

    it 'Access assoication' do
      expect(express_method.subscriber).to eq user
    end
  end

  describe "#rate_as" do
    it 'Convert rate in current unit to another unit' do
      expect(express_method.unit).to eq 'kg'
      expect(express_method.rate_as 'lb').to eq 2.20462
    end
  end
  
  describe "#can_delete?" do
    it "Model cannot delete if goods are assoicated" do
      expect(express_method.can_delete?).to eq false
    end
  end

end
