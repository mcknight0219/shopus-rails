class PhotoController< ApplicationController
  
  def create 
    puts params[:id]
    render :json => {:status => 'ok'}       
  end

  def destroy
    render :json => {:status => 'ok'}
  end

  private

end
