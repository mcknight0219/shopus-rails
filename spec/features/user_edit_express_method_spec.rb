require 'rails_helper'

feature 'Subscriber edit his shipping method', :js => true do
  let(:user) { create(:a_subscriber) }
  let(:shipping) { create(:a_shipping_method, subscriber: user) }

  before(:all) do
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!
  end

  scenario 'subscriber visit the page and see his shipping methods' do
    visit '/edit_express'
    binding.pry
    expect(page).to have_content(shipping.company)
  end
end
