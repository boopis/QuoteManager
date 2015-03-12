module Ahoy
  class Event < ActiveRecord::Base
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user
    belongs_to :targetable, polymorphic: true
  end
end
