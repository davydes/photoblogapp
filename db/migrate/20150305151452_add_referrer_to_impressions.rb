class AddReferrerToImpressions < ActiveRecord::Migration
  def change
    add_column :impressions, :referer, :string
  end
end
