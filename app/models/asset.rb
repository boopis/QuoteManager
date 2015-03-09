class Asset < ActiveRecord::Base
  belongs_to :account
  belongs_to :request
  mount_uploader :asset, FileUploader
end
