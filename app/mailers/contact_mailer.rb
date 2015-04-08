class ContactMailer < ActionMailer::Base
  def send_email(contact, template, sender, subject)
    @contact, @template = contact, template
    mail to: contact.email, subject: subject, from: sender
  end
end
