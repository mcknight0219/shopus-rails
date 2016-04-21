class GoodsController < ApplicationController
  include SnsapiBase

  before_action :snsapi_base_auth

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

  def detroy
  end
end
