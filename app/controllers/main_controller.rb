class MainController < ApplicationController
  def index
    if session[:oauth_access_token] then
      graph = Koala::Facebook::API.new(session[:oauth_access_token])
      @profile = graph.get_object("me")
      @time = Time.now.to_i
      @client_id = Digest::SHA1.hexdigest([Time.now, rand].join).encode('UTF-8')
    end
  end
end
