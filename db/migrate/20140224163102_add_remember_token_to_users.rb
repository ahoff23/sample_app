class AddRememberTokenToUsers < ActiveRecord::Migration
  #Adds a remember_token column to the user database
  #This tracks whether or not the user is signed in (it is a string)
  def change
  	add_column :users, :remember_token, :string
  	add_index :users, :remember_token
  end
end
