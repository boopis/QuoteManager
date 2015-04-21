require 'net/http'
require 'json'

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def to_params
    {
      'refresh_token' => refresh_token,
      'client_id' => ENV['GOOGLE_CLIENT_ID'],
      'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
      'grant_type' => 'refresh_token'
    }
  end

  def self.find_for_oauth(auth)
    identity = Identity.find_by_uid(auth.uid)
    if identity.nil?
      find_or_create_by(
        uid: auth.uid, 
        provider: auth.provider, 
        social_name: auth['info']['email'], 
        access_token: auth['credentials']['token'],
        refresh_token: auth['credentials']['refresh_token'],
        expires_at: Time.at(auth['credentials']['expires_at'])
      )
    else
      identity
    end
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
      access_token: data['access_token'],
      expires_at: Time.now + (data['expires_in'].to_i).seconds
    )
  end

  def expired?
    expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    access_token
  end

end
