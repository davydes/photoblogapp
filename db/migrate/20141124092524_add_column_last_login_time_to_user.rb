class AddColumnLastLoginTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_login_time, :datetime
  end
end
