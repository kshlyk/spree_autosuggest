class AddProductIdToSuggestions < ActiveRecord::Migration
  def change
    add_column :spree_suggestions, :product_id, :integer
  end
end
