class AddPasswordDigestToUsers < ActiveRecord::Migration
  #Add a new columm to users table
  #called with 'rails generate migration [migration_name] [column_name] :string'
  def change
    add_column :users, :password_digest, :string
  end
end

#To migrate and test:
#bundle exec rake db:migrate
#bundle exec rake test:prepare  <-- Sync database in db/development.sqlite3 with test database
#bundle exec rake rspec spec/