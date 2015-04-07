class QuoteStateMachine
  include Statesman::Machine

  # Define states
  state :draft, initial: :true
  state :sent
  state :in_discussion
  state :accepted
  state :declined

  # Define transition rules
  transition from: :draft, to: :sent
  transition from: :sent, to: [:accepted, :declined]
end
