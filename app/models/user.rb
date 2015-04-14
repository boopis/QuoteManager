class User < ActiveRecord::Base
  belongs_to :account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :avatar, as: :viewable, dependent: :destroy, :class_name => Image
  accepts_nested_attributes_for :avatar, :account

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  validate :limit, :on => :create, :if => :plan_exists?

  has_many :identities

  acts_as_messageable

  def limit
    if self.account.users(:reload).count >= self.account.plan.users
      errors.add(:base, "Exceeds User Limit, Please Upgrade Your Account")
    end
  end

  def plan_exists?
    self.account.present?
  end

  def fullname
    firstname + ' ' + lastname
  end

  def mailboxer_email(object)
    case object
    when Mailboxer::Message
      return nil
    when Mailboxer::Notification
      return nil
    end
  end

  def role?(role)
    self.role.include? role
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

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    if !signed_in_resource.nil? && identity.user != signed_in_resource 
      identity.user = signed_in_resource
      identity.save!
    end

    !signed_in_resource.nil? ? signed_in_resource : identity.user
  end
end
