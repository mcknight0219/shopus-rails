module Wechat
  class Error < StandardError
    attr_reader :errcode

    def initialize(errmsg, errcode = nil)
      super(errmsg)
      @errcode = errcode
    end

    class << self
      def from_response(body)
        new(body[:errmsg], body[:errcode])
      end
    end
  end
end
