class Form < ActiveRecord::Base
  has_many :requests

  validates :name, presence: true
  validates :fields, presence: true

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
  def map_destination_data(req)
    self.sync_dynamic_field
    self.active_dynamic_validator

    req[:fields].each do |key, value|
      self.fields[key]["request"] = value[:request]
    end

    # Check data is valid and return errors
    self.valid?
    self.errors
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
end
