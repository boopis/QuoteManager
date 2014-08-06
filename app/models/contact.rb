class Contact < ActiveRecord::Base
  has_many :requests
end
