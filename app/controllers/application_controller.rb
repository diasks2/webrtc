class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_globals
  
  def set_globals
    @title = "WebRTC"
  end
end
