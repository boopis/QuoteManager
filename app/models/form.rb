class Form < ActiveRecord::Base
  has_many :requests

  validates :name, presence: true
  validates :fields, presence: true
end
