require 'rails_helper'
require 'rake'

feature 'Subscriber edit his shipping method', :js => true do
  let!(:user) { create(:a_subscriber) }
  let!(:shipping) { create(:a_shipping_method, subscriber: user) }

  before(:all) do
    WebMock.allow_net_connect!
    precompile_asset_task
  end

  after(:all) do
    WebMock.disable_net_connect!(allow: %r{/hub/session})
    clobber_asset_task
  end

  scenario 'subscriber visit the page and see his shipping methods' do
    visit '/edit_express'
    expect(page).to have_content(denormalize shipping.company)
    find('.weui_media_box.weui_media_text').click 

    expect(page).to have_content("Edit #{denormalize shipping.company}")
    expect(page).to have_selector("input[placeholder='#{shipping.rate}']")
    expect(page).to have_select('unit_option', :selected => shipping.unit)
    expect(page).to have_select('time_option', :selected => shipping.duration)
  end

  # scenario 'subscriber decides to delete one shipping methods' do
  #   visit '/edit_express'
  #   find('.weui_media_box.weui_media_text').click

  #   within("#editor_dialog") do
  #     expect(page).to have_link('Delete shipping method', href: "/express/#{shipping.id}")
  #   end
  # end


  def denormalize(s)
    s.split('_').map { |w| w.capitalize }.join(' ')
  end

  def precompile_asset_task
    Rails.application.load_tasks
    silence_stream(STDOUT) do
      Rake::Task['assets:precompile'].invoke
    end
  end

  def clobber_asset_task
    Rake::Task['assets:clobber'].invoke
  end
end
