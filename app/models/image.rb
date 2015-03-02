class Image < ActiveRecord::Base
  belongs_to :viewable, polymorphic: true
  mount_uploader :image, ImageUploader
end
