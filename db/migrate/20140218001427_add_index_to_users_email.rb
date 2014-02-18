class AddIndexToUsersEmail < ActiveRecord::Migration
  #Add an index to the users table for :email
  #Called with 'rails generate migration [migration_name]'
  #def must be manually entered
  def change
  	add_index :users, :email, unique: true
  end
end

#To migrate and test:
#bundle exec rake db:migrate
#bundle exec rake test:prepare  <-- Sync database in db/development.sqlite3 with test database
#bundle exec rake rspec spec/