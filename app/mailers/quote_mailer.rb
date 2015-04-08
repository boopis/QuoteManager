class QuoteMailer < ActionMailer::Base
  def send_quote(address, quote, template, sender)
    @quote, @template = quote, template
    mail to: address, subject: "Quote link", from: sender
  end
end
