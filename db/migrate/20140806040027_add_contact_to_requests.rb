class AddContactToRequests < ActiveRecord::Migration
  def change
    add_reference :requests, :contact, index: true
  end
end
