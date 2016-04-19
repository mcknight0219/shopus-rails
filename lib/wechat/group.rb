module Wechat
  class Group
    extend Api

    class << self
      # Create a new named group
      #
      # @return Json
      # @example
      # {
      #   "group": {
      #     "id": 107,
      #     "name": "test"
      #   }
      # }
      #
      #
      def create(name)
        perform_request 'post', 'groups/create', :json => {:group => {:name => name}}
      end

      # Get all groups
      #
      # @return Json
      # @example
      # {
      #   "groups": {
      #     {
      #       "id": 0,
      #       "name": "未分组"
      #       "count": 123
      #     },
      #     {
      #       "id": 1,
      #       "name": "黑名单"
      #       "count": 0
      #     }
      #   }
      # }
      #
      def get
        perform_request 'get', 'groups/get'
      end

      # Query the group id for a subscriber
      #
      # @return Json
      # @example
      # {
      #   "groupid": 102
      # }
      def get_id(open_id)
        perform_request 'post', 'groups/getid', :json => {:openid => openid}
      end

      # Change the name of a group
      #
      # @return Json
      def update(id, name)
        perform_request 'post', 'groups/update', :json => {:group => {:id => id, :name => name}}
      end

      # Move a user to specific group
      #
      # @return Json
      def move_user_group(open_id, group_id)
        perform_request 'post', 'groups/member', :json => {:openid => opend_id, :to_groupid => group_id}
      end

      # Delelte a group. All users inside this group will be moved to
      # default group
      #
      # @return Json
      def delete(id)
        perform_request 'post', 'groups/delete', :json => {:group => {:id => id}}
      end
    end
  end
end
