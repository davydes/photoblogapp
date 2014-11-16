class AddUploadLimitsToUser < ActiveRecord::Migration
  def change
    add_column :users, :photo_upload_daily_limit, :integer
    add_column :users, :photo_upload_weekly_limit, :integer
  end
end
