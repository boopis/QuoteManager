class Request < ActiveRecord::Base
  belongs_to :form
  belongs_to :contact

  def self.find_json(key,term)
    where("fields -> '#{key}' ->> 'request' ILIKE ?", "%#{term}%")
  end

  ransacker :key
  ransacker :term

  def self.ransackable_scopes(auth_object = nil)
    %i(key term)
  end
end
