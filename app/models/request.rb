class Request < ActiveRecord::Base
  belongs_to :form
  belongs_to :contact
end
