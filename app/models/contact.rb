class Contact < ActiveRecord::Base
  belongs_to :account
  has_many :requests

  validates :email,   
            :presence => true,   
            :uniqueness => true,   
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }  

  has_one :avatar, as: :viewable, dependent: :destroy, class: Image
  accepts_nested_attributes_for :avatar

  def load_image(default_img)
    if avatar.nil? || avatar.image_url.nil?
      default_img
    else
      avatar.image_url(:thumb).to_s
    end
  end
end
