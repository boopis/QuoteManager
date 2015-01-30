class Form < ActiveRecord::Base
  has_many :requests

  validates :name, presence: true
  validates :fields, presence: true

  # Define setter and getter for dynamic field
  #   def add_dynamic_field(field_name)
  #    self.class.instance_eval do
  # 
  #       # Define getter method
  #       define_method(field_name) do  
  #         fields[field_name]
  #      end
  # 
  #       # Define setter method
  #       define_method("#{field_name}=") do |value|
  #         self.fields = (fields || {}).merge(field_name => value) 
  #       end
  #     end
  #  end
  # 
  #   # Add new validator
  #   def add_validator(field_name, validator) 
  #     validators[field_name] = validator
  #  end
  # 
  #   # Create all setter and getter for all member in fields
  #   def sync_dynamic_field
  #     self.fields.each_key do |key|
  #       self.add_dynamic_field(key)
  #     end
  #  end
  # 
  #   # Active validator for each field in fields
  #   def active_dynamic_validator
  #     self.validators.each do |k, v|
  #       self.singleton_class.instance_eval do 
  #         self.send(v, k.to_sym)
  #       end
  #     end
  #   end
end
