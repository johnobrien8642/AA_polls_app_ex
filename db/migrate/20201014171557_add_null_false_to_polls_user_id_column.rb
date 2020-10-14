class AddNullFalseToPollsUserIdColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :polls, :user_id, :integer, null: false
  end
end
