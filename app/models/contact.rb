class Contact < ActiveRecord::Base
  belongs_to :account
  has_many :requests

  validates :email,   
            :presence => true,   
            :uniqueness => true,   
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }  

  has_one :avatar, as: :viewable, dependent: :destroy, class: Image
  accepts_nested_attributes_for :avatar

  has_one :note, as: :notable
  accepts_nested_attributes_for :note

  liquid_methods :name, :phone, :email

  def load_image(default_img)
    if avatar.nil? || avatar.image_url.nil?
      default_img
    else
      avatar.image_url(:thumb).to_s
    end
  end

  def self.update_or_create_form_submitted(req_fields, request, account_id)
    contact = [
      req_fields.find{|k,v| v['type'] == 'name'}.try(:last) || {},
      req_fields.find{|k,v| v['type'] == 'phone'}.try(:last) || {},
      req_fields.find{|k,v| v['type'] == 'email'}.try(:last) || {}
    ]

    name, phone, email = contact.map { |c| c['request'] } 

    if email.present?
      contact = Contact.find_by_email(email) || Contact.new
      contact.assign_attributes(
        :email => email, 
        :name => name, 
        :phone => phone, 
        :account_id => account_id
      )
      contact.requests << request
      contact.save
    end
  end
end
