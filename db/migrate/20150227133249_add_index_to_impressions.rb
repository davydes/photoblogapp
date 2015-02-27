class AddIndexToImpressions < ActiveRecord::Migration
  def change
    add_index :impressions, [:impressionable_type, :impressionable_id]
  end
end
