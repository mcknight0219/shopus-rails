class GoodsController < ApplicationController
  include MainHelper
  include Identity
  
  before_action :assert_granted, only: [:index, :new]

  def index
  end

  def new
  end
  
  def create
    begin
      post_process Good.create!(params.permit(:name, :brand, :price, :currency, :description).merge(subscriber: current_subscriber))
      redirect_to :controller => :express_select, :action => :new
    rescue => e
      flash[:error] = '无法创建新的商品，请稍后重试'
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
      return unless current_subscriber.nil?
      return render template: :unauthorized unless params.key? :code
      auth_with_wechat
    end

    def post_process(good)
      UploadsProcessJob.perform_later session[:uploads] if session[:uploads].present?
      session[:good_in_creating] = good.id
    end
end
