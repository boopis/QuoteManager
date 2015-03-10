class FormMailer < ActionMailer::Base
  default from: "sir1003dem@gmail.com"

  def alert_to_form_creators(receiver, user, form)
    @form, @user, @receiver = form, user, receiver
    mail to: receiver, subject: "Request From ##{form.id} form.name"
  end

  def thank_customer(customer, form)
    @form, @customer = form, customer
    mail to: customer.email, subject: "Thank you for using our services"
  end
end
