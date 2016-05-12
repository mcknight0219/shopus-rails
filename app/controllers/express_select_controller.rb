class ExpressSelectController < ApplicationController
  include MainHelper

  def new
    @express = ExpressMethod.where(:subscriber => current_subscriber)
  end

  def create
    render :success
  end
end
