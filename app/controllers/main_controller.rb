class MainController < ApplicationController
  def index
    if session[:oauth_access_token] then
      graph = Koala::Facebook::API.new(session[:oauth_access_token])
      @profile = graph.get_object("me")
    end
  end
end
