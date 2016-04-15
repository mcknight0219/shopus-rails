module Wechat

  class Error < StandardError
    attr_reader :errcode

    def initialize(errmsg, errcode = nil)
      super(errmsg)
      @errcode = errcode
    end

    class << self
      def from_response(body)
        message, code = parse_error(body)
        if code == 0
          new(message, code)
        else
          nil
        end
      end

      private

        def parse_error(body)
          if body.nil? || body.empty? || ! body.has_key?(:errcode)
            ['', nil]
          elsif body[:errcode]
            [body[:errmsg], body[:errcode]]
          end
        end
    end
  end
end