class CreatePoll < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.integer :user_id
      t.string :title, null: false

      t.timestamps
    end

    add_index :polls, :user_id
  end
end
