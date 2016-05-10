class PhotoController< ApplicationController
  
  def create 
    puts params[:id]
    render :json => {:status => 'ok'}       
  end

  def destroy
  end

  private

end
