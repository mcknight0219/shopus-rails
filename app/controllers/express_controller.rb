class ExpressController < ApplicationController
  include MainHelper
  #before_action :assert_user_presence

  def index
    @methods = ExpressMethod.find_by(:subscriber => current_subscriber)
  end

  def new

  end

  def create
    method = ExpressMethod.create(params.permit(:company, :country, :unit, :rate, :duration, :note).merge(subscriber: current_subscriber))
    mode = if method.valid? then 'success' else 'failure' end
    redirect_to action: 'index', mode: mode
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
    def assert_user_presence
      render "unauthorized" unless session[:openid]
    end
end
