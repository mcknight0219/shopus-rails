class GoodsController < ApplicationController
  include Identity
  
  before_action :assert_granted, only: [:index, :new]

  def index
  end

  def new
  end
  
  def create
    begin
      new_one = Good.create! params.permit(:name, :brand, :price, :currency, :description)
      UploadsProcessJob.perform_later session[:uploaded_files]
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
end
