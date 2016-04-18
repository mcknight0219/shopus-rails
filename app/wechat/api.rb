require 'error'

module Wechat
  module Api
    BASE_URI = "https://api.weixin.qq.com/cgi-bin".freeze

    def token
      Rails.cache.fetch("wechat_access_token", expires_in: 1.hour + 59.minutes) do
          params ||= {}
          params[:grant_type] = 'client_credential'
          params[:appid]  = Rails.application.secrets.wechat_app_id
          params[:secret] = Rails.application.secrets.wechat_app_secret
          (error_or_body HTTP.get("#{BASE_URI}/token", :params => params).parse)[:access_token]
      end
    end

    def perform_request(verb, path, **args)
      %w[get, post].include? verb.downcase ? verb.downcase : 'get'
      path.start_with?('/') or (path = '/' + path)
      args[:params] = {} unless args.key?(:params)
      args[:params][:access_token] = token

      error_or_body (HTTP.request verb, BASE_URI + path, args).parse
    end

    def error_or_body(body)
      body = sym_recursive body

      return body if body.nil? || body.empty?
      return body if ! body.key?(:errcode) || body[:errcode] == 0
      raise Wechat::Error.from_response(body)
    end

    def sym_recursive e
      return e.map { |e| sym_recursive e } if e.is_a? Array
      return e.inject({}) { |h, (k, v)| h[k.to_sym] = sym_recursive(v); h } if e.is_a? Hash
      e
    end
  end
end
