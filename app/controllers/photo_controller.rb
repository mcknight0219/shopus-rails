class PhotoController< ApplicationController
  def create 
    pp = ProductPhoto.create :temp_path => params[:file].tempfile.path, :format => params[:file].content_type
    session[:uploads] ||= []
    session[:uploads] << pp.id
    render :json => {:status => 'ok', :id => pp.id}       
  end

  def destroy
    ProductPhoto.delete params[:id]
    session[:uploads].delete_if { |id| params[:id].to_i == id }
    session.delete :uploads if session[:uploads].empty?
    render :json => {:status => 'ok'}
  end
end
