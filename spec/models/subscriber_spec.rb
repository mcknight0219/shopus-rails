require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it "create a subscriber" do
    sub = Subscriber.create(weixin: 'weixin account')
    expect(sub).to_not be_nil
    expect(sub.is_seller).to be_falsey
    expect(sub.weixin).to eq 'weixin account'
  end

  it "create a subscriber who is seller" do
      seller = Subscriber.create(weixin: 'weixin account', is_seller: true)
      expect(Subscriber.seller.size).to eq 1
      expect(Subscriber.seller.first.is_seller).to be_truthy
      expect(Subscriber.find_by(:weixin => 'weixin account').id).to eq seller.id
  end
end
