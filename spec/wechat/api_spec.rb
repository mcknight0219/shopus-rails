require 'rails_helper'
require 'api'

RSpec.describe Wechat do
  let(:extended_class) {Class.new { include Wechat }}

  it 'issue a request to get access token' do
    stub_request(:get, Wechat::BASE_URI + "/token?appid=wxfd9d6d2aba92b679&grant_type=client_credential&secret=a5a98315d29a068f2d437353a44f5594").
      to_return(:body => "{\"access_token\": \"token\", \"expires_in\": 7200}",
      :status => 200, :headers => {'Content-Type' => 'application/json'})

    expect(extended_class.token).to eq 'token'
  end
end
