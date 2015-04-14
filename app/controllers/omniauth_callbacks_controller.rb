class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if !@user.nil? && current_user.nil?
          sign_in(@user)
          redirect_to root_path, flash: { notice: "Logged in by #{provider.capitalize} successful!" }
        elsif !@user.nil? && !current_user.nil?
          redirect_to user_path(@user), flash: { notice: "Your account is connected to #{provider.capitalize}." }
        else
          redirect_to new_user_session_path, flash: { error: "You must manually login and connect to #{provider.capitalize}." }
        end
      end
    }
  end

  [:google_oauth2].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    #if resource.email_verified?
      #super resource
    #else
      #finish_signup_path(resource)
    #end
  end
end
