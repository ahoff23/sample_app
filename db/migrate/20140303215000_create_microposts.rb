class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    #Add an index which searches by both user id and creation time at the same time
    #Think of it as a composite key from EECS 212
    add_index :microposts, [:user_id, :created_at]
  end
end
