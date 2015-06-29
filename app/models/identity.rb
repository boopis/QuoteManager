require 'net/http'
require 'json'

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  scope :by_google_account, ->(account_id) {
    joins(:user)
    .where('users.account_id' => account_id)
    .where(provider: 'google_oauth2')
    .first
  }

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
end
