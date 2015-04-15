class AddAnalyticToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :os, :string
    add_column :requests, :referrer, :string
    add_column :requests, :remote_ip, :string
    add_column :requests, :language, :string
    add_column :requests, :browser, :string
    add_column :requests, :time_to_complete, :integer
  end
end
