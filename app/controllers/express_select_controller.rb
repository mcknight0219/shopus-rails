class ExpressSelectController < ApplicationController
  include MainHelper

  def new
    @express = ExpressMethod.where(:subscriber => current_subscriber)
  end

  def create
    product = Good.find session[:good_in_creating]
    product.update :express_method, ExpressMethod.find(params[:express_method])
    PublishProductJob.perform_later product
    render :success
  end
end
