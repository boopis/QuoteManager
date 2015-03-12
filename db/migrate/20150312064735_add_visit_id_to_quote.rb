class AddVisitIdToQuote < ActiveRecord::Migration
  def change
    add_reference :quotes, :visit, index: true
  end
end
