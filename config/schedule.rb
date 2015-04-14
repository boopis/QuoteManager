every :day, :at => '00:00am', :roles => [:app] do
  rake "quote:incomplete_reminder"
end
