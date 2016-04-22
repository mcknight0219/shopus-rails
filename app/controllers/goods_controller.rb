class GoodsController < ApplicationController
  include Identity
  before_action :userable_on_grant

  def index
  end

  ##
  # All to-be-vendor user will first land on this page.
  # After they upload an item, they automatically become
  # a vendor
  def new
    render :new
  end

  # Form is submitted asynchronously
  def create
    Product.create(params[:product])
  end

  def show
  end

  def update
  end

  def detroy
  end

  private
    def userable_on_grant
      render "unauthorized" unless params.key?(:code)
    end
end
