class Quote < ActiveRecord::Base
  belongs_to :account
  belongs_to :template
  belongs_to :request, :autosave => true
  before_create :generate_token
  liquid_methods :amount, :options, :id, :token, :expires_at, :description

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  has_many :visitors, as: :eventable, dependent: :destroy, :class_name => Visit
  has_many :transitions, class_name: "QuoteTransition"

  # Initialize the state machine
  def state_machine
    @state_machine ||= QuoteStateMachine.new(self, transition_class: QuoteTransition,
                                             association_name: :transitions)
  end

  # Optionally delegate some methods
  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, to: :state_machine

  scope :analytics, ->(quote_id) { 
    where(:id => quote_id)
    .includes(:visitors => :ahoy_events)
    .where(:ahoy_events => { :name => '[Quote]End' } ) 
  }

  scope :from_contact, ->(contact_id) {
    joins(:request)
    .where(:requests => {:contact_id => contact_id })
  }

  scope :nearly_expire, -> {
    includes(:account)
    .where(expires_at: 1.day.ago..2.days.from_now)
    .order('account_id DESC')
  }

  def self.incomplete_reminder
    nearly_quotes = nearly_expire

    nearly_quotes.select do |quote|
      ['draft', 'sent', 'in_discussion'].include? quote.current_state
    end
  end

protected

  def generate_token
    self.token = SecureRandom.urlsafe_base64(nil, false)
  end
end
