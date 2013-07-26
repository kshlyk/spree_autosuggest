class RenameTrigramToSpreeTrigram < ActiveRecord::Migration
  def change
    rename_table :trigrams, :spree_trigrams
  end
end
