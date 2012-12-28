class AuthController < ApplicationController
  def facebook_authenticate
    oauth = Koala::Facebook::OAuth.new(462002327169885, '2b388517ef755cb8416a38b3d500d2eb',
            'http://localhost:3000/auth/facebook_callback')
    oauth.get_user_info_from_cookies(cookies)
    oauth_url = oauth.url_for_oauth_code
    redirect_to oauth_url
  end

  def facebook_callback
    if params[:error] then
      flash[:error] = "Unable to login. Please try again."
      redirect_to :controller => :main, :action => :index
    else
      oauth = Koala::Facebook::OAuth.new(462002327169885, '2b388517ef755cb8416a38b3d500d2eb',
              'http://localhost:3000/auth/facebook_callback')
      session[:oauth_access_token] = oauth.get_access_token(params[:code])
      
      redirect_to :controller => :main, :action => :index
    end
  end
  
  def logout
    session.delete(:oauth_access_token)
    redirect_to :controller => :main, :action => :index
  end
end
