require 'roo'

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

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

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
      req_fields.find{|k,v| v['type'] == 'email'}.try(:last) || {},
      req_fields.find{|k,v| v['type'] == 'title'}.try(:last) || {},
      req_fields.find{|k,v| v['type'] == 'description'}.try(:last) || {}
    ]

    name, phone, email, title, description = contact.map { |c| c['request'] } 

    if email.present?
      contact = Contact.find_by_email(email) || Contact.new
      contact.assign_attributes(
        :email => email, 
        :name => name, 
        :phone => phone, 
        :title => title, 
        :description => description, 
        :account_id => account_id
      )
      contact.requests << request
      contact.save
    end
  end

  def self.import(file, account_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    contacts = []
    msg = 'Import errors: <br/>'

    (2..spreadsheet.last_row).each do |i|
      contacts.push(Contact.find_or_initialize_by(Hash[[header, spreadsheet.row(i)].transpose].merge!({account_id: account_id})))
    end

    if contacts.map(&:valid?).all?
      ActiveRecord::Base.transaction do
        contacts.each(&:save!)
      end
      msg = ''
    else
      contacts.each_with_index do |contact, index|
        contact.errors.full_messages.each do |message|
          msg = msg + "Row #{index + 2}: #{message} <br/>"
        end
      end
    end

    msg
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
