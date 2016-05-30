require 'rails_helper'
require 'rake'

feature 'Subscriber edit his shipping method', :js => true do
  let(:user) { create(:a_subscriber) }
  let(:shipping) { create(:a_shipping_method, subscriber: user) }

  before(:all) do
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!(allow: %r{/hub/session})
  end

  scenario 'subscriber visit the page and see his shipping methods' do
    visit '/edit_express'
    expect(page).to have_content(shipping.company)
  end


  def denormalize(s)
    s.split('_').map { |w| w.capitalize }.join(' ')
  end
end
