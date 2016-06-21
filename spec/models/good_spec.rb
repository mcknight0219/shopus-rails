require 'rails_helper'

RSpec.describe Good, type: :model do
  it "create a good object" do
    user = create(:a_subscriber)
    g = Good.create(:name => 'Name', :brand => 'Brand', :currency => 'CAD', :price => 123, :description => 'TEXT', :subscriber => user)
    expect(g.brand).to eq 'Brand'
    expect(g.price).to be_a Money

    expect(g.price.cents).to eq 12300
    expect(g.price.currency.iso_code).to eq 'CAD'
  end

  it "create a good object that belongs to a subscriber" do
    user = create(:a_subscriber)
    g = Good.create(:name => 'Name', :brand => 'Brand', :currency => 'USD', :price => 123, :description => 'TEXT', :subscriber => user)
    expect(user.goods.length).to eq 1
    expect(g.subscriber).to eq user
  end

  it "delete a subscriber also destroy all his goods" do
    
  end
end
