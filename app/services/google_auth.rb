require 'net/http'
require 'json'

class GoogleAuth
  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def to_params
    {'refresh_token' => identity.refresh_token,
     'client_id' => ENV['GOOGLE_CLIENT_ID'],
     'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
     'grant_type' => 'refresh_token'}
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    if data['access_token'].present?
      identity.update_attributes(access_token: data['access_token'],
                             expires_at: Time.now + (data['expires_in'].to_i).seconds)
    end
  end

  def expired?
    identity.expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    identity.access_token
  end

end
