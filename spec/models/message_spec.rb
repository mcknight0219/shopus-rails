require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'created from a user sent message' do
    msg = Message.new(:from => 'user', :to => 'us', :type => 'text', :content => 'hello world')
    expect(msg.user_sent?).to be_truthy
    expect(msg.event?).to be_falsey
    expect(msg.content).to eq('hello world')
  end

  it 'created from an scan subscribe event' do
    msg = Message.new(:from => 'user', :to => 'us', :type => 'event', :event => 'subscribe', :event_key => 'random key', :ticket => 'ticket')
    expect(msg.user_sent?).to be_falsey
    expect(msg.event?).to be_truthy
    expect(msg.scan_subscribe_event?).to be_truthy
    expect(msg.event_key).to eq 'random key'
  end
end 