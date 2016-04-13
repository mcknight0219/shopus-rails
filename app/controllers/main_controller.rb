require 'digest/sha1'

class MainController < ApplicationController
  def index
    first_time? and render text: check_signature_and_return, content_type: 'text/plain'  
  end

  def disptach
  end

  private

    def check_signature_and_return
      params[:signature] == Digest::SHA1.hexdigest([Rails.application.secrets.wechat_token, params[:timestamp], params[:nonce]].sort!.join) ? params[:echostr] : ''
    end

    # First time wexin will send a request to verify. So check
    # all required fields exist
    def first_time?
      (['signature', 'nonce', 'echostr', 'timestamp'].select { |i| !params.key? i}).empty?
    end
end
