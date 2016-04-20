require 'nokogiri'
require 'digest/sha1'

class MainController < ApplicationController
  include MainHelper

  def index
    first_time? && render(text: check_signature_and_return, content_type: 'text/plain')
  end

  def create
    m = Message.new(extract_hash_from_xml (Nokogiri::Slop request.body.read).xml)
    dispatch(m) do |result|
      render text: result, content_type: 'application/xml'
    end
  end

  private

  def dispatch(message)
    yield AccountStrategy.new(message).consume if message.account_event?
  end

  def check_signature_and_return
    params[:signature] == Digest::SHA1.hexdigest([Rails.application.secrets.wechat_token, params[:timestamp], params[:nonce]].sort!.join) ? params[:echostr] : ''
  end

  # First time Weixin will send a request to verify. So check
  # all required fields exist
  def first_time?
    (%w(signature nonce echostr timestamp).select { |i| !params.key? i }).empty?
  end
end
