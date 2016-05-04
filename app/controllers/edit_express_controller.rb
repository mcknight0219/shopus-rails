# Simple proxy controller that delegates real work
# to ExpressController
class EditExpressController < ApplicationController
  def index
    @express = ExpressMethod.all       
  end
end
