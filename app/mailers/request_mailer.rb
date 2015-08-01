class RequestMailer < ActionMailer::Base
  def response_to_customer(user, subject, response_msg)
    @user, @response_msg = user, response_msg
    mail to: user, subject: subject
  end
end
