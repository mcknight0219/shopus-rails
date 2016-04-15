require 'nokigiri'
require 'digest/sha1'

class MainController < ApplicationController

  def index
    first_time? and render text: check_signature_and_return, content_type: 'text/plain'  
  end

  def create
    m = Message.new(extract_hash_from_xml (Nokogiri::Slop request.body.read).xml)
    dispatch_message m do |r|
      # Response could either be a xml string or a simple 'success'
      if r =~ /success/
        render text: r, content_type: 'text/plain'
      else
        render xml: r
      end
    end
  end

  private

    def check_signature_and_return
      params[:signature] == Digest::SHA1.hexdigest([Rails.application.secrets.wechat_token, params[:timestamp], params[:nonce]].sort!.join) ? params[:echostr] : ''
    end

    # First time Weixin will send a request to verify. So check
    # all required fields exist
    def first_time?
      (['signature', 'nonce', 'echostr', 'timestamp'].select { |i| !params.key? i}).empty?
    end
end
