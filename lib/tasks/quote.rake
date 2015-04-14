namespace :quote do

  desc "Alert to user about incomplete quote" 
  task :incomplete_reminder => :environment do 
    QuoteReminders.incomplete_reminder
  end

end
