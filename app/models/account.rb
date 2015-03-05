class Account < ActiveRecord::Base
  belongs_to :plan
  has_many :forms, :dependent => :destroy
  has_many :requests, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users
  validates :company_name, :presence => true

  validates :plan_id, presence: true, numericality: { only_integer: true }
  validate :validate_plan_id

  has_one :company_logo, as: :viewable, dependent: :destroy, :class => Image
  accepts_nested_attributes_for :company_logo

  attr_accessor :stripe_card_token

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(email: users[0].email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
  end

private

  def validate_plan_id
    errors.add(:plan_id, "is invalid") unless Plan.exists?(self.plan_id)
  end
end
