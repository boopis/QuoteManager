class Request < ActiveRecord::Base
  belongs_to :account
  belongs_to :form
  belongs_to :contact
  validate :limit, :on => :create

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  def limit
    if self.account.requests(:reload).where('created_at >= ?', 1.month.ago).count >= self.account.plan.requests
      errors.add(:base, "Account limit reached for requests. Please contact the owner of this form.")
    end
  end

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

  def time_to_complete_form
    Time.at(time_to_complete / 1000).strftime("%M minute(s) %S second(s)")
  end
end
