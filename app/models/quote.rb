class Quote < ActiveRecord::Base
  belongs_to :request

protected

  def generate_token
    self.token = SecureRandom.urlsafe_base64(nil, false)
  end
end
