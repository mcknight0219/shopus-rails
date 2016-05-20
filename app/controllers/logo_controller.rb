class LogoController < ApplicationController
  def show
    logo = Logo.find_by(:name => params[:name])
    return render :json => {:status => 'ok'} if logo.nil?
    return render :json => {:status => 'ok', :type => 'url', :data => logo.url} if logo.remote?
    render :json => {:status => 'ok', :type => 'data', :data => logo.data}
  end
end
