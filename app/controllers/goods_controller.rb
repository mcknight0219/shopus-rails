class GoodsController < ApplicationController
  include Identity
  
  before_action :assert_granted, only: [:index, :new]

  def index
  end

  def new
  end
  
  def create
    begin
      post_process Good.create!(params.permit(:name, :brand, :price, :currency, :description))
      render 'express/index'
    rescue => e
      flash[:error] = 'Error creating product'
      render :new
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
    def assert_granted
      return render template: :unauthorized unless params.key? :code
      auth_with_wechat
    end

    def post_process(good)
      UploadsProcessJob.perform_later session[:uploads] if session[:uploads].present?
      session[:good_in_creating] = good.id
    end
end
