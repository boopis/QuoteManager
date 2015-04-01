class Plan < ActiveRecord::Base
  has_many :accounts

  # Get limitation of plan and return [users, forms, requests, storage]
  def limitation
    [users, forms, requests, storage]
  end
end
