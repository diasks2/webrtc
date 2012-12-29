class AuthController < ApplicationController
  def facebook_authenticate
    oauth = Koala::Facebook::OAuth.new(Rails.application.config.facebook_app_id,
              Rails.application.config.facebook_app_secret,
              'http://' + Rails.application.config.host  + '/auth/facebook_callback')
    oauth.get_user_info_from_cookies(cookies)
    oauth_url = oauth.url_for_oauth_code
    redirect_to oauth_url
  end

  def facebook_callback
    if params[:error] then
      flash[:error] = "Unable to login. Please try again."
      redirect_to :controller => :main, :action => :index
    else
      oauth = Koala::Facebook::OAuth.new(Rails.application.config.facebook_app_id,
              Rails.application.config.facebook_app_secret,
              'http://' + Rails.application.config.host  + '/auth/facebook_callback')
      session[:oauth_access_token] = oauth.get_access_token(params[:code])
      
      redirect_to :controller => :main, :action => :index
    end
  end
  
  def logout
    session.delete(:oauth_access_token)
    redirect_to :controller => :main, :action => :index
  end
end
