class ExpressSelectController < ApplicationController
  include MainHelper

  def new
    @express = ExpressMethod.where(:subscriber => current_subscriber)
  end

  def create
    item = update_product
    ProductPublishJob.perform_later item if params[:publish]
    render :success
  end

  private

    def update_product
      product = Good.find session[:good_in_creating]
      product.update :express_method => ExpressMethod.find(params[:express_method])
      product
    end
end
