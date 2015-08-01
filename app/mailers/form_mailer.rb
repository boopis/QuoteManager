class FormMailer < ActionMailer::Base
  def alert_to_form_creators(receiver, user, form, request)
    @form, @user, @receiver, @request = form, user, receiver, request
    mail to: receiver, subject: "Request ##{request.id} for #{form.name}"
  end

  def thank_customer(customer, form)
    @form, @customer = form, customer
    mail to: customer.email, subject: "Thank you for using our services"
  end
end
