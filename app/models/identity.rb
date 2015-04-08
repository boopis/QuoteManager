class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(
      uid: auth.uid, 
      provider: auth.provider, 
      social_name: auth['info']['email'], 
      url: auth['info']['urls'].values[0], 
      token: auth['credentials']['token'], 
      expires_at: Time.at(auth['credentials']['expires_at'])
    )
  end

end
