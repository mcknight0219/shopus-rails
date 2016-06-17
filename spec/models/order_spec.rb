require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user)   { create(:a_subscriber) }
  let!(:order)  { create(:order) }
  
end
