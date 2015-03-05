class Request < ActiveRecord::Base
  belongs_to :account
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

  def has_mismatch_field?
    !((self.fields.detect { |k, v| !v['form_mismatched'].nil? }).nil?)
  end

  def mismatch_fields 
    self.fields.select { |k, v| !v['form_mismatched'].nil? }
  end
end
