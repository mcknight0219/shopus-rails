class ExpressController < ApplicationController
  include MainHelper
  before_action :assert_user_presence

  def index
    @express = ExpressMethod.where(:subscriber => current_subscriber)
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
    express = ExpressMethod.find params[:id]
    unless express.can_delete?
      render :json => {:status => 'bad', :errmsg => 'Cannot remove the express emthod.'}
    else
      render :json => {:status => 'ok'}
  end

  private
    def assert_user_presence
      render template: 'goods/unauthorized' unless current_subscriber    
    end
end
