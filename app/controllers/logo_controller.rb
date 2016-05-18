class LogoController < ApplicationController
  def show
    render :json => {:status => 'ok'}
  end
end
