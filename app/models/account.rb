class Account < ActiveRecord::Base
  has_many :forms, :dependent => :destroy
  has_many :requests, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users
  validates :company_name, :presence => true

  has_one :company_logo, as: :viewable, dependent: :destroy, :class => Image
  accepts_nested_attributes_for :company_logo
end
