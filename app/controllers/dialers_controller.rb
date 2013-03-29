class DialersController < ApplicationController
  def index
    if session[:oauth_access_token] then
      graph = Koala::Facebook::API.new(session[:oauth_access_token])
      @profile = graph.get_object("me")
      
      default_client = ENV["TWILLIO_CLIENT_NAME"]
      account_sid = ENV["TWILLIO_SID"]
      auth_token = ENV["TWILLIO_AUTH_TOKEN"]
      capability = Twilio::Util::Capability.new account_sid, auth_token
      # Create an application sid at twilio.com/user/account/apps and use it here
      capability.allow_client_outgoing ENV["TWILLIO_CLIENT_OUTGOING"]
      capability.allow_client_incoming default_client
      @token = capability.generate
    end
  end
  
  def voice
    caller_id = ENV["TWILLIO_CALLER_ID"]
    
    number = params[:PhoneNumber]
    response = Twilio::TwiML::Response.new do |r|
        # Should be your Twilio Number or a verified Caller ID
        r.Dial :callerId => caller_id do |d|
          # Test to see if the PhoneNumber is a number, or a Client ID. In
          # this case, we detect a Client ID by the presence of non-numbers
          # in the PhoneNumber parameter.
          if /^[\d\+\-\(\) ]+$/.match(number)
            d.Number(CGI::escapeHTML number)
          else
            d.Client default_client
          end
        end
    end
    render :text => response.text
  end
end
