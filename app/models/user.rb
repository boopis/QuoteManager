class User < ActiveRecord::Base
  belongs_to :account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :avatar, as: :viewable, dependent: :destroy, :class_name => Image
  accepts_nested_attributes_for :avatar, :account

  validate :limit, :on => :create

  def limit
    if self.account.users(:reload).count >= self.account.plan.users
      errors.add(:base, "Exceeds User Limit, Please Upgrade Your Account")
    end
  end

  def fullname
    firstname + ' ' + lastname
  end

  def load_image(type, default_img)
    if type == :avatar
      src = avatar
    elsif type == :company_logo
      src = self.account.company_logo
    end

    if src.nil? || src.image_url.nil?
      default_img
    else
      src.image_url(:thumb).to_s
    end
  end
end
