class GoodsController < ApplicationController
  include Identity
  before_action :userable_on_grant, :assert_user_presence

  def index
  end

  ##
  # All to-be-vendor user will first land on this page.
  # After they upload an item, they automatically become
  # a vendor
  def new
    render :new
  end

  def create
    
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
    def userable_on_grant
      return render :unauthorized unless params.key?(:code)
      auth
    end
end
