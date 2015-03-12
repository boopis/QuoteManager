class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  Ahoy.track_visits_immediately = true
  Ahoy.visit_duration = 30.minutes
  Ahoy.quiet = false
end
