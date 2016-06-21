require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:prod) { build(:a_product) }
  subject { build(:a_order, :good => prod) }
  
  it 'could access the subscriber' do
    expect(subject.subscriber).to eq prod.subscriber
  end

  it 'subscriber have an alias' do
    expect(subject.seller).to eq prod.subscriber
  end

  it 'could access currency and price' do
    expect(subject.currency).to eq 'CAD'
    expect(subject.price.cents).to eq 9999 
  end

  it 'could ship if having shipping method' do
    expect(subject.ready_to_ship?).to be_truthy
  end

  it 'has initial state when created' do
    expect(subject.state_name).to eq :ordered
    expect(subject.order_note).to eq 'Order created'
    expect(subject.time_used).to  eq 0
  end

  describe '@stat' do
    it 'order fullfilled' do
      subject.take
      subject.ship
      subject.confirm
      expect(subject.state_name).to eq :fullfilled
    end

    it 'cancel order after' do
      expect(subject).to receive(:cancel)
      subject.cancel
    end
  end
end
