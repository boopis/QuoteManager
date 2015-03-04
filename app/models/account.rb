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

private

  def validate_plan_id
    errors.add(:plan_id, "is invalid") unless Plan.exists?(self.plan_id)
  end
end
