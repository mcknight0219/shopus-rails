class PhotoController< ApplicationController
  
  def create 
    session[files_key] ||= {}
    session[params[:id]] = params[:file][:tempfile].path 
    
    render :json => {:status => 'ok'}       
  end

  def destroy
    session[files_key].delete params[:id]  
  end

  private
  def files_key
    "#{session[:openid]}_files".to_sym
  end
end
