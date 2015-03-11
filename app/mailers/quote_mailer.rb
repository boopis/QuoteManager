class QuoteMailer < ActionMailer::Base
  default from: "sir1003dem@gmail.com"

  def send_quote(address, quote, template)
    @quote, @template = quote, template
    mail to: address, subject: "Quote link"
  end
end
