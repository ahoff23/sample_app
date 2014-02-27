class AddAdminToUsers < ActiveRecord::Migration
  #Add an admin column to the database with a default value of false because
  #users should not be admins by default
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
