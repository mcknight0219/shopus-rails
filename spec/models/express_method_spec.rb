require 'rails_helper'

RSpec.describe ExpressMethod, type: :model do
  it 'Create an instance of ExpressMethod' do
    user = create(:a_subscriber)
    express_method = ExpressMethod.create(company: 'company name', unit: 1, rate: 1.1, country: 'canada', duration: 1, description: 'description', subscriber: user)
    expect(express_method).to_not be_nil
    expect(express_method.unit).to eq 'kg'
    expect(express_method.shipping_estimate).to eq 'less than a week'
    expect(express_method.subscriber).to eq user
    expect(ExpressMethod.find_by(:company => 'company name').id).to eq express_method.id
  end

  it 'Convert rate in current unit to another unit' do
    user = create(:a_subscriber)
    express_method = ExpressMethod.create(company: 'company name', unit: 1, rate: 1.0, country: 'canada', duration: 1, description: 'description', subscriber: user)
    expect(express_method.unit).to eq 'kg'
    expect(express_method.rate_as 'lb').to eq 2.20462
  end

end
