class Form < ActiveRecord::Base
  belongs_to :account
  has_many :requests

  validates :name, presence: true
  validates :fields, presence: true
  validate :empty_form_field_option, :must_have_email_field, :empty_label

  # organize form field by position
  def order_form_field_position
    fields.sort_by do |key, value|
      value['position'].to_i
    end
  end

  # Define setter and getter for dynamic field
  def add_dynamic_field(field_name)
    self.class.instance_eval do

      # Define getter method
      define_method('f' + field_name) do  
        fields[field_name]["request"]
      end

      # Define setter method
      define_method("f#{field_name}=") do |value|
        self.fields[field_name]["request"] = value 
      end
    end
  end

  # Get data from destination object to validate
  def map_destination_data(req, request)
    self.sync_dynamic_field
    self.active_dynamic_validator

    req[:fields].each do |key, value|
      unless self.fields[key].nil?
        self.fields[key]["request"] = value[:request]
      else
        # Request and form are mismatched
        # Missing field will be marked in request json data
        # We will alert to form creator and user 
        # Request index page must show this problem
        request.fields[key]['form_mismatched'] = 'Form mismatched'
      end
    end

    # Check data is valid and return errors
    self.valid?
    { errors: self.errors, request: request }
  end

  # Create all setter and getter for all member in fields
  def sync_dynamic_field
    self.fields.each_key do |key|
      self.add_dynamic_field(key)
    end
  end

  # Active validator for each field in fields
  def active_dynamic_validator
    self.fields.each do |key, value|
      
      if value["validate"].present?

        value["validate"].each do |k, v|
          
          if v == '1'
            self.singleton_class.instance_eval do 
              self.send(k, "f#{key}".to_sym)
            end
          end
        end

      end

    end
  end

  def empty_label
    is_empty_label = false
    self.fields.each do |key, value|
      is_empty_label = true if value['label'].empty?
    end
    errors.add(:form, "can't save with form field have no label") if is_empty_label
  end

  def must_have_email_field
    is_contain_email_field = false
    self.fields.each do |key, value|
      is_contain_email_field = true if value['type'] == 'email'
    end
    unless is_contain_email_field
      errors.add(:form, "can't save without email field")
    end
  end

  def empty_form_field_option
    self.fields.each do |key, value|
      type = value['type']
      if((type == 'radio' || type == 'select' || type == 'checkbox') && 
         (value['options'].nil? || value['options'].length == 0)) 
        errors.add("#{type} field".to_sym, "can't save with empty options")
      end
    end
  end

end
