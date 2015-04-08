class ContactMailer < ActionMailer::Base
  def send_email(contact, template, sender, address, subject)
    @contact, @template = contact, template
    mail to: address, subject: subject, from: sender
  end
end
