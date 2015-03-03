class FormMailer < ActionMailer::Base
  default from: "sir1003dem@gmail.com"

  def form_submitted(receiver, user, form)
    @form = form
    @user = user
    @receiver = receiver
    mail to: receiver, subject: "Request From ##{form.id} form.name"
  end
end
