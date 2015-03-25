class Quote < ActiveRecord::Base
  belongs_to :account
  belongs_to :template
  belongs_to :request, :autosave => true
  before_create :generate_token
  liquid_methods :amount, :options, :id, :token, :expires_at, :description

  has_many :visitors, as: :eventable, dependent: :destroy, :class_name => Visit

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  scope :analytics, ->(quote_id) { 
    where(:id => quote_id)
    .includes(:visitors => :ahoy_events)
    .where(:ahoy_events => { :name => '[Quote]End' } ) 
  }

  scope :from_contact, ->(contact_id) {
    joins(:request)
    .where(:requests => {:contact_id => contact_id })
  }

protected

  def generate_token
    self.token = SecureRandom.urlsafe_base64(nil, false)
  end
end
