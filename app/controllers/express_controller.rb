class ExpressController < ApplicationController
  include MainHelper
  before_action :assert_user_presence, :except => [:index] 

  def index
    render :json => {:status => 'ok', :express => ExpressMethod.all.to_a.map { |e| e.as_json :except => [:updated_at] } }
  end

  def new
      
  end

  def create
    method = ExpressMethod.create(params.permit(:company, :country, :unit, :rate, :duration, :description).merge(subscriber: current_subscriber))
    mode = if method.valid? then 'success' else 'failure' end
    redirect_to controller: 'express_select', action: 'new', mode: mode
  end

  def show
  end

  def update
    updates = params.permit :company, :country, :unit, :rate, :duration, :description
    ExpressMethod.find(params[:id]).update_columns updates unless updates.empty?
    render :json => {:status => 'ok'}
  end

  def destroy
    express = ExpressMethod.find params[:id]
    unless express.can_delete?
      render :json => {:status => 'bad', :errmsg => 'Cannot remove the express emthod.'}
    else
      express.delete      
      render :json => {:status => 'ok'}
    end
  end

end
