class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  Ahoy.quiet = false

  def track_visit(options)
    visit = Visit.new do |v|
      v.id = ahoy.visit_id
      v.visitor_id = ahoy.visitor_id
      v.user = user if v.respond_to?(:user=)
      v.started_at = options[:started_at]
      v.eventable_type = options['eventable_type']
      v.eventable_id = options['eventable_id']
    end

    set_visit_properties(visit)

    begin
      visit.save!
      geocode(visit)
    rescue *unique_exception_classes
      # do nothing
    end
  end

  def track_event(name, properties, options)
    event = Ahoy::Event.new do |e|
      e.id = options[:id]
      e.visit_id = ahoy.visit_id
      e.user = user
      e.name = name
      e.properties = properties
      e.time = options[:time]
    end

    begin
      event.save!
    rescue *unique_exception_classes
      # do nothing
    end
  end

  def current_visit
    ahoy.visit
  end

end
