require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it "create a subscriber" do
    sub = Subscriber.create(weixin: 'weixin account')
    expect(sub).to_not be_nil
    expect(sub.is_seller).to be_falsey
    expect(sub.active).to be_truthy
  end
end
