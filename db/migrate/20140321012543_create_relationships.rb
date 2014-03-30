class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    #Add indices to search relationships by follower_id and by followed_id
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    #Add a composite index for relaioships which tracks each follower and 
    #corresponding follower_id seperately. unique: true ensures no repetition is allowed
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
