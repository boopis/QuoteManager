class Account < ActiveRecord::Base
  belongs_to :plan
  has_many :forms, :dependent => :destroy
  has_many :requests, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :templates, :dependent => :destroy
  accepts_nested_attributes_for :users
  validates :company_name, :presence => true

  has_one :company_logo, as: :viewable, dependent: :destroy, :class => Image
  accepts_nested_attributes_for :company_logo

  validates :plan, presence: true, :on => :update

  liquid_methods :company_logo, :company_name

  attr_accessor :stripe_card_token
end
