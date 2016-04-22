module Wechat
  class Menu
    extend Api

    class << self
      ##
      # Create menu layout defined as json
      #
      # @return Json
      def create(menu)
        perform_request 'post', 'menu/create', :json => menu
      end

      ##
      # Get the definition of the menu
      #
      # @return Json
      # @example
      # {
      #   "menu": {
      #     "button": [
      #       {
      #         "type": "click",
      #         "name": "今日歌曲",
      #         "key": "V1001_TODAY_MUSIC",
      #         "sub_button": [],
      #       }
      #     ]
      #   },
      #   "conditionalmenu": {
      #     "button": [
      #       {
      #         "type": "view",
      #         "name": "搜索",
      #         "url": "http://www.soso.com/",
      #         "sub_button": [ ]
      #       }
      #     ]
      #   },
      # }
      #
      def get
        perform_request 'get', 'menu/get'
      end

      ##
      # If we have conditional menu defined
      #
      # @return Boolean
      def has_conditional?
        body = get
        body.key?(:conditionalmenu)
      end

      ##
      # Delete the menu including conditional menu if also defined
      #
      # @return Json
      def delete
        perform_request 'get', 'menu/delete'
      end

      ##
      # we only show conidtional menu for registered seller
      #
      # @return Json
      # @example
      # {
      #   "menuid": "208379533"
      # }
      def create_conditional(menu, group_id)
        menu[:matchrule] ||= {:group_id => group_id}
        perform_request 'post', :json => menu
      end

      ##
      # Delete the conditional menu
      #
      # @return Json
      #
      def delete_conditional(menu_id)
        perform_request 'post', 'menu/delconditional', :json => {:menuid => menu_id}
      end

      ##
      # Get the menu configuration for a particular user
      #
      # @return Json
      # @example
      # {
      #   "button": [
      #       {
      #           "type": "view",
      #           "name": "tx",
      #           "url": "http://www.qq.com/",
      #           "sub_button": [ ]
      #       }
      #   ]
      # }
      def test_conditional(open_id)
        perform_request 'post', 'menu/trymatch', :json => {:user_id => open_id}
      end
    end
  end
end