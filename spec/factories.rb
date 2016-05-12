FactoryGirl.define do
  factory :subscribe_event, class: Message do
    initialize_with do
      new(:type => 'event', :from => 'customer', :to => 'us', :event => 'subscribe', :create_time => Time.now.to_i)
    end
  end

  factory :unsubscribe_event, class: Message do
    initialize_with do
      new(:type => 'event', :from => 'customer', :to => 'us', :event => 'unsubscribe', :create_time => Time.now.to_i)
    end
  end

  factory :a_subscriber, class: Subscriber do
    weixin "customer"
    created_at { Time.now.to_s }
    updated_at { Time.now.to_s }
  end

  factory :a_shipping_method, class: ExpressMethod do
    company 'shuntong'
    unit    1
    rate    3.33
    country 'Canada'
    duration 1
    description ''
    association :subscriber, factory: :a_subscriber 
    created_at { Time.now.to_s }
  end
end
