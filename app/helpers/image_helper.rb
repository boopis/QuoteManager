module ImageHelper
  def avatar(user)
    if user.image.present?
      user.image_url(:thumb).to_s
    else
      default_url = "#{root_url}assets/guest.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "https://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    end
  end
end