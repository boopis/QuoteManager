class Account < ActiveRecord::Base
  has_many :forms, :dependent => :destroy
  has_many :requests, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users
  validates :name, :presence => true
end
