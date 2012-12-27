class DialersController < ApplicationController
  def index
    @client_id = Digest::SHA1.hexdigest([Time.now, rand].join).encode('UTF-8')
    @time = Time.now.to_i
  end
end
