class ExpressSelectController < ApplicationController
  include MainHelper

  def new
    @express = ExpressMethod.where(:subscriber => current_subscriber)
  end

  def create
  end
end
