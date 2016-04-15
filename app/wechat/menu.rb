module Wechat
  module Menu
    # Create menu layout
    def create

    end

    def get
      Wechat.perform_request 'get', 'menu/get'
    end

    def delete
      Wechat.perform_request 'get', 'menu/delete'
    end

    def has_conditional?
      get.key?(:conditional)
    end
  end
end