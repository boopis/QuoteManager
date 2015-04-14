class QuoteReminders
  
  # Search all incomplete quote nearly expired time and alert to user
  def self.incomplete_reminder
    quotes = Quote.incomplete_reminder
    reminders = {} 

    quotes.each do |quote|
      reminders[quote.account] = '' if reminders[quote.account_id].nil?
      reminders[quote.account] += "Incomplelte quote no #{quote.id} is nearly expired \n"
    end

    ActiveRecord::Base.transaction do 
      reminders.each do |k, v|
        Mailboxer::Notification.notify_all(k.users, 'Incomplete Quotes reminder', v, send_mail = false)
      end
    end
  end
end
