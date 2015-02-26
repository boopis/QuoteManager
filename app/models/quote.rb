class Quote < ActiveRecord::Base
  belongs_to :request, :autosave => true
  before_create :generate_token

protected

  def generate_token
    self.token = SecureRandom.urlsafe_base64(nil, false)
  end
end
