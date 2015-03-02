class User < ActiveRecord::Base
  belongs_to :account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :avatar, as: :viewable, dependent: :destroy, :class_name => Image
  accepts_nested_attributes_for :avatar

  validates :phone_number, numericality: true

  def fullname
    firstname + ' ' + lastname
  end

  def load_avatar(default_img)
    if avatar.new_record? || avatar.image.file.nil?
      default_img
    else
      avatar.image_url(:thumb).to_s
    end
  end
end
