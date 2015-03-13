class AddSocialMediaToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :social_media, :hstore
  end
end
