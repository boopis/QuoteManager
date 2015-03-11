class AddTemplateToQuotes < ActiveRecord::Migration
  def change
    add_reference :quotes, :template, index: true
  end
end
