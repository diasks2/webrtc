class DialersController < ApplicationController
  def index
    if session[:oauth_access_token] then
      graph = Koala::Facebook::API.new(session[:oauth_access_token])
      @profile = graph.get_object("me")
      
      default_client = 'webrtcphone'
      account_sid = 'AC8299501d55c3b6c62d7b304cc48c9bf7'
      auth_token = '3c686e6607dd19528396571cd9bf975a'
      capability = Twilio::Util::Capability.new account_sid, auth_token
      # Create an application sid at twilio.com/user/account/apps and use it here
      capability.allow_client_outgoing "AP3e36a472688f5917dc76724025fb1e3d"
      capability.allow_client_incoming default_client
      @token = capability.generate
    end
  end
  
  def voice
    caller_id = "+12066733169"
    
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
