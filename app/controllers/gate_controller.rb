class GateController < ApplicationController
  include Identity
  before_action :grant_and_validate, only: [:index]

  def index
    path = goods_url
    if params.key? :redirectTo
      path = sanitize_path params[:redirectTo]
    end
    redirect_to path
  end

  private
    def grant_and_validate
      return render template: :unauthorized unless params.key? :code
      auth_with_wechat
    end

    def sanitize_path(path) 
      return "/#{path}" unless path.start_with? '/'
      path
    end
end
